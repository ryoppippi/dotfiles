#!/usr/bin/env nu

# Update the npm packages defined in default.nix to their latest published
# version, refreshing the source hash, package-lock.json, and npmDepsHash.
#
# Usage: ./update.nu [pname...]      # all packages when none are named

const DEFAULT_NIX = 'default.nix'

# A `key = "value";` field inside one mkNpmPackage block, or null when absent.
# Anchored to the start of a line so `hash` cannot match `npmDepsHash`.
def field [block: string, key: string]: nothing -> any {
    # Concatenated rather than interpolated: `(?m)` and `(?<value>...)` would
    # each be read as an interpolation inside a $'...' string.
    $block
    | parse --regex ('(?m)^\s*' + $key + ' = "(?<value>[^"]*)";')
    | get --optional 0.value
}

# Replace one field inside a block. The old value is matched literally, which
# avoids escaping a hash into a regex and cannot stray outside this block.
def set-field [
    block: string
    key: string
    old: string
    new: string
]: nothing -> string {
    $block | str replace $'($key) = "($old)";' $'($key) = "($new)";'
}

# Every mkNpmPackage block, carrying its own text so an update can be written
# back by replacing that exact block. Blocks are self-delimiting, so no pattern
# ever has to reach across two packages the way the previous perl calls did.
def packages [text: string]: nothing -> table {
    $text
    | parse --regex '(?s)(?<block>mkNpmPackage \{.*?\n  \};)'
    | get block
    | each {|block|
        let pname = field $block pname
        {
            block: $block
            pname: $pname
            npm_name: (field $block npmName | default $pname)
            version: (field $block version)
            hash: (field $block hash)
            deps_hash: (field $block npmDepsHash)
        }
    }
}

# Swap one block for its updated text and persist the file.
def save-block [old_block: string, new_block: string]: nothing -> nothing {
    open --raw $DEFAULT_NIX
    | str replace $old_block $new_block
    | save --force $DEFAULT_NIX
}

# npm pack the published tarball and let npm resolve a fresh lockfile from it.
# --ignore-scripts because we only want the dependency graph, not a build.
def regenerate-lock [npm_name: string, lock_file: path]: nothing -> nothing {
    print '  Regenerating package-lock.json'
    let tmp = mktemp --directory
    let target = $lock_file | path expand --no-symlink

    # `cd` inside a plain `def` is scoped to this block, so the caller's
    # directory needs no saving and restoring.
    cd $tmp
    ^npm pack $npm_name --pack-destination .
    ^tar -xzf (ls *.tgz | get 0.name) --strip-components=1
    ^npm install --package-lock-only --ignore-scripts
    cp package-lock.json $target
    rm --recursive --force $tmp
}

# The hash nix reports as the actual npm dependency hash, or null when the
# build failed for some other reason.
def fetch-deps-hash [npm_name: string]: nothing -> any {
    print '  Calculating new npmDepsHash (this may take a moment)...'
    let expr = '((import <nixpkgs> {}).callPackage ./. {})."' + $npm_name + '"'
    let result = ^nix build --impure --expr $expr | complete

    # nix prints the mismatch as `specified: <wrong>` / `got: <right>`.
    [$result.stdout, $result.stderr]
    | str join "\n"
    | parse --regex 'got:\s+(?<hash>\S+)'
    | get --optional 0.hash
}

# Bring one package up to its latest published version. Returns the updated
# block text, or null when nothing changed.
def update-package [pkg: record]: nothing -> any {
    print $"Checking ($pkg.npm_name)..."

    if $pkg.version == null {
        print $"  Could not find current version for ($pkg.pname)"
        return null
    }

    let published = ^npm view $pkg.npm_name version | complete
    if $published.exit_code != 0 {
        print $"  Could not fetch latest version for ($pkg.npm_name)"
        return null
    }
    let latest = $published.stdout | str trim

    if $pkg.version == $latest {
        print $"  Already at latest version: ($pkg.version)"
        return null
    }

    print $"  Updating from ($pkg.version) to ($latest)"
    let bumped = set-field $pkg.block version $pkg.version $latest
    save-block $pkg.block $bumped

    let url = $"https://registry.npmjs.org/($pkg.npm_name)/-/($pkg.pname)-($latest).tgz"
    print $"  Fetching new hash for ($url)"
    let prefetched = ^nix-prefetch-url --unpack $url | complete
    if $prefetched.exit_code != 0 {
        error make {msg: $"failed to prefetch ($url)"}
    }
    let sri = ^nix hash convert --hash-algo sha256 --to sri ($prefetched.stdout | lines | last)

    let hashed = set-field $bumped hash $pkg.hash $sri
    save-block $bumped $hashed

    # The lockfile has to land before npmDepsHash is computed: nix hashes the
    # dependency graph that lockfile pins.
    let lock_file = $pkg.pname | path join package-lock.json
    if ($lock_file | path exists) {
        regenerate-lock $pkg.npm_name $lock_file
    }

    let deps_hash = fetch-deps-hash $pkg.npm_name
    let final = if $deps_hash == null {
        $hashed
    } else {
        let updated = set-field $hashed npmDepsHash $pkg.deps_hash $deps_hash
        save-block $hashed $updated
        $updated
    }

    print $"  Updated ($pkg.npm_name) to ($latest)"
    $final
}

def main [...only: string]: nothing -> nothing {
    cd ($env.CURRENT_FILE | path dirname)

    let all = packages (open --raw $DEFAULT_NIX)
    let targets = if ($only | is-empty) { $all } else {
        $all | where pname in $only
    }

    let unknown = $only | where {|name| $name not-in ($all | get pname) }
    if ($unknown | is-not-empty) {
        error make {msg: $"unknown package\(s): ($unknown | str join ', ')"}
    }

    print 'Updating npm packages...'

    # Sequential on purpose: each package rewrites default.nix, and its
    # npmDepsHash is computed from the file as written.
    for pkg in $targets {
        update-package $pkg
    }

    print ''
    print 'Update complete!'
}
