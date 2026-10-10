#!/usr/bin/env nix
#! nix shell --inputs-from . nixpkgs#nushell --command nu

# Every git hook for this repository, behind one entry point.
#
# git-hooks.nix installs a one-line trampoline as .git/hooks/<name> that execs
# this script with <name> as its first argument. The four post-* hooks all boil
# down to "re-apply what the changed files imply", differing only in the diff
# range that describes what just happened, so they share one implementation
# instead of being four near-copies.
#
# Usage: git-hooks.nu <pre-commit|post-commit|post-checkout|post-merge|post-rewrite> [hook args...]

# Touching any of these means the Nix configuration has to be re-applied.
const NIX_PATTERN = '^(flake\.nix|flake\.lock|nix/|nvim/nvimx-lock/)'
const DICT_PATTERN = '^typewhisper/dictionary\.json'
# Editing a plugin spec can add or drop plugins the nvimx lock has to pin.
const NVIM_SPEC_PATTERN = '^nvim/lua/plugin/'
const NVIMX_LOCK_DIR = 'nvim/nvimx-lock'
const NVIMX_LOCK_OUTPUTS = ['plugins.json', 'flake.nix', 'flake.lock']

# Paths touched in a diff range. Empty when git cannot resolve the range, which
# is how a missing HEAD^ or ORIG_HEAD has always been treated here.
def changed [range: string]: nothing -> list<string> {
    let result = ^git diff $range --name-only | complete

    if $result.exit_code != 0 {
        []
    } else {
        $result.stdout | lines | where {|path| $path | is-not-empty }
    }
}

# True while a rebase, merge, or cherry-pick is in flight. Those replay commits
# one at a time and only the final state is worth switching to.
def mid-operation []: nothing -> bool {
    let git_dir = ^git rev-parse --git-dir | str trim

    ['rebase-merge', 'rebase-apply', 'MERGE_HEAD', 'CHERRY_PICK_HEAD']
    | any {|entry| $git_dir | path join $entry | path exists }
}

# Re-apply whatever the changed set implies. `occasion` only shapes the message.
def apply-implied [range: string, occasion: string = '']: nothing -> nothing {
    let files = changed $range

    if ($files | any {|path| $path =~ $NIX_PATTERN }) {
        print $"Nix configuration changed($occasion). Applying changes..."
        ^nix run .#switch
    }

    if ($files | any {|path| $path =~ $DICT_PATTERN }) {
        print $"TypeWhisper dictionary changed($occasion). Syncing..."
        # The commit has already happened, so a failed sync must not fail the hook.
        do --ignore-errors { ^./typewhisper/dict-sync.nu } | ignore
    }
}

def staged-files [--filter: string = 'ACMR']: nothing -> list<string> {
    ^git diff --cached --name-only $"--diff-filter=($filter)"
    | lines
    | where {|path| $path | is-not-empty }
}

# Re-lock the Neovim plugins when a plugin spec changed, and return the files
# that now need staging. Existing pins stay put; only added or removed plugins
# change the lock. A failure only warns: a plugin missing from the lock is
# simply absent until the next run. An offline `nvimx-lock --check`
# (myuron/nvimx#78) would make this cheaper.
def relock-nvim []: nothing -> list<string> {
    # Deletions count too: dropping a spec file drops its plugin from the lock.
    if not (staged-files --filter 'ACMRD' | any {|path| $path =~ $NVIM_SPEC_PATTERN }) {
        return []
    }

    print 'Neovim plugin specs changed. Re-locking with nvimx...'
    # Without DOTFILES_DIR the app locks the main checkout, not this worktree.
    let root = ^git rev-parse --show-toplevel | str trim
    let result = with-env {DOTFILES_DIR: $root} { do { ^nix run .#nvim-lock } | complete }

    if $result.exit_code != 0 {
        print --stderr "warning: nvimx-lock failed; run 'nix run .#nvim-lock' manually"
        return []
    }

    let generated = $NVIMX_LOCK_OUTPUTS | each {|name| $NVIMX_LOCK_DIR | path join $name }
    ^git add ...$generated
    $generated
}

# Stash unstaged work so treefmt only ever sees staged content; without it,
# formatting would sweep unrelated edits into the commit.
def stash-unstaged []: nothing -> bool {
    let dirty = (^git diff --quiet | complete | get exit_code) != 0
    let untracked = ^git ls-files --others --exclude-standard | str trim | is-not-empty

    if not ($dirty or $untracked) {
        return false
    }

    ^git stash --quiet --keep-index --include-untracked
    true
}

def pre-commit []: nothing -> nothing {
    let staged = staged-files
    # A commit that only deletes files can still drop a plugin spec.
    if ($staged | is-empty) and (staged-files --filter 'D' | is-empty) {
        return
    }

    let stashed = stash-unstaged

    # Re-lock only once the stash leaves the working tree equal to the index,
    # so the lock matches the specs being committed. Regenerating adds files to
    # the commit, so fold them into the set that is re-staged after formatting.
    let tracked = $staged | append (relock-nvim)

    print 'Running treefmt on staged files...'
    let formatted = do { ^nix run .#fmt } | complete

    # treefmt may have rewritten staged files. Re-stage those exact paths and
    # nothing else — a list, so a path containing a space stays one path.
    let present = $tracked | where {|path| $path | path exists }
    if ($present | is-not-empty) {
        ^git add ...$present
    }

    if $stashed {
        ^git stash pop --quiet
    }

    print $formatted.stdout
    if $formatted.exit_code != 0 {
        print --stderr 'treefmt failed'
        exit 1
    }
}

def post-commit []: nothing -> nothing {
    if (mid-operation) {
        return
    }
    apply-implied 'HEAD^..HEAD'
}

# git passes: previous HEAD, new HEAD, and a flag that is 1 for a branch
# checkout and 0 when only files were restored.
def post-checkout [args: list<string>]: nothing -> nothing {
    if ($args | get --optional 2) == '0' or (mid-operation) {
        return
    }
    apply-implied 'HEAD@{1}..HEAD'
}

def post-merge []: nothing -> nothing {
    apply-implied 'HEAD@{1}..HEAD'
}

# git passes either `rebase` or `amend`; amend is post-commit's job.
def post-rewrite [args: list<string>]: nothing -> nothing {
    if ($args | get --optional 0) != 'rebase' {
        return
    }
    apply-implied 'ORIG_HEAD..HEAD' ' after rebase'
}

def main [hook: string, ...args: string]: nothing -> nothing {
    match $hook {
        'pre-commit' => (pre-commit)
        'post-commit' => (post-commit)
        'post-checkout' => (post-checkout $args)
        'post-merge' => (post-merge)
        'post-rewrite' => (post-rewrite $args)
        _ => {
            print --stderr $"git-hooks: unknown hook ($hook)"
            exit 2
        }
    }
}
