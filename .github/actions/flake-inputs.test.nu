use std/assert
use flake-inputs.nu [root-input first-parent-expressions select-aged-commit]

def commit [repository: path, date: string, message: string]: nothing -> string {
    with-env {GIT_AUTHOR_DATE: $date, GIT_COMMITTER_DATE: $date} {
        ^git -C $repository -c commit.gpgsign=false commit --quiet --allow-empty -m $message
    }
    ^git -C $repository rev-parse HEAD | str trim
}

def parent-page [repository: path, revision: string]: nothing -> list<any> {
    first-parent-expressions $revision
    | each --keep-empty {|expression|
        let result = (^git -C $repository show --no-patch --no-show-signature '--format=%H%x09%cI' $expression | complete)
        if $result.exit_code != 0 { return null }
        let fields = $result.stdout | str trim | split row "\t"
        {oid: ($fields | first), committedDate: ($fields | last)}
    }
}

def main [] {
    let nodes = {
        root: {
            inputs: {nixpkgs: nixpkgs_2}
        }
        nixpkgs: {
            original: {ref: nixpkgs-unstable}
        }
        nixpkgs_2: {
            original: {ref: nixos-unstable}
        }
    }
    assert equal (root-input $nodes nixpkgs | get original.ref) nixos-unstable
    assert equal (root-input $nodes missing) null

    let repository = mktemp -d
    try {
        ^git init --quiet --initial-branch=main $repository
        ^git -C $repository config user.name 'Flake input test'
        ^git -C $repository config user.email 'flake-inputs@example.invalid'
        ^git -C $repository config core.hooksPath /dev/null
        let root = commit $repository '2026-01-01T12:00:00Z' root
        let base = commit $repository '2026-01-02T12:00:00Z' base
        ^git -C $repository checkout --quiet -b side $root
        let side = commit $repository '2026-01-04T12:00:00Z' side
        ^git -C $repository checkout --quiet main
        with-env {GIT_AUTHOR_DATE: '2026-01-06T12:00:00Z', GIT_COMMITTER_DATE: '2026-01-06T12:00:00Z'} {
            ^git -C $repository -c commit.gpgsign=false merge --quiet --no-ff side -m merge
        }
        let cutoff = 2026-01-05T12:00:00Z
        let page = parent-page $repository main
        assert equal (select-aged-commit $page $cutoff | get sha) $base
        assert equal (select-aged-commit (parent-page $repository HEAD) $cutoff | get sha) $base
        assert equal (select-aged-commit (parent-page $repository side) $cutoff | get sha) $side
        assert equal (select-aged-commit $page 2025-12-01T00:00:00Z | get status) none
        assert equal (select-aged-commit $page 2026-01-02T12:00:00Z | get sha) $base

        for index in 1..140 {
            (commit
                $repository
                '2026-01-07T12:00:00Z'
                $"new-($index)"
            ) | ignore
        }
        let first_page = select-aged-commit (parent-page $repository main) $cutoff
        assert equal $first_page.status more
        let second_page = parent-page $repository $"($first_page.sha)~1"
        assert equal (select-aged-commit $second_page $cutoff | get sha) $base
    } catch {|err|
        rm -rf $repository
        error make $err
    }
    rm -rf $repository
    print 'Flake input regression checks passed'
}
