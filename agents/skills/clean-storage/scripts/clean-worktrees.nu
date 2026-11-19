#!/usr/bin/env nix
#! nix shell nixpkgs#nushell nixpkgs#coreutils --command nu

# GraphQL batches avoid one request per worktree; Git checks for dirtiness again
# when removing a candidate without --force.

const BATCH = 100

def --wrapped git-result [...args: string]: nothing -> record {
    ^git ...$args | complete
}

def --wrapped git-output [...args: string]: nothing -> string {
    let result = git-result ...$args
    if $result.exit_code != 0 {
        error make {msg: $"git ($args | str join ' ') failed: ($result.stderr | str trim)"}
    }
    $result.stdout | str trim
}

def --wrapped gh-result [...args: string]: nothing -> record {
    ^gh ...$args | complete
}

def worktrees [repo: string]: nothing -> list<record> {
    let root = git-output -C $repo rev-parse --show-toplevel | path expand
    let result = git-result -C $repo worktree list --porcelain -z
    if $result.exit_code != 0 {
        error make {
            msg: $"git worktree list failed in ($repo): ($result.stderr | str trim)"
        }
    }
    let output = $result.stdout
    $output
    | split row "\0\0"
    | where { $in | str starts-with 'worktree ' }
    | each {|block|
        let fields = $block | split row "\0"
        let path_line = $fields | where { $in | str starts-with 'worktree ' } | first
        let head_line = $fields | where { $in | str starts-with 'HEAD ' } | first
        let branch_line = $fields | where { $in | str starts-with 'branch ' } | get 0? | default ''
        let lock_line = $fields | where { $in | str starts-with 'locked' } | get 0? | default ''
        {
            path: ($path_line | str replace 'worktree ' '' | path expand)
            head: ($head_line | str replace 'HEAD ' '')
            branch: ($branch_line | str replace 'branch refs/heads/' '')
            locked: ($lock_line | str starts-with 'locked')
        }
    }
    | where path != $root
}

def current-worktree [path: string]: nothing -> bool {
    let current = pwd | path expand
    $current == $path or ($current | str starts-with ($path + '/'))
}

def path-protected [path: string, keep_paths: list<string>]: nothing -> bool {
    $keep_paths | any {|kept|
        let prefix = if $kept == '/' { '/' } else { $kept + '/' }
        $path == $kept or ($path | str starts-with $prefix)
    }
}

def pull-requests [repo: string, branches: list<string>]: nothing -> list<record> {
    if ($branches | is-empty) { return [] }

    let repo_info = do {
        cd $repo
        gh-result repo view --json owner,name
    }
    if $repo_info.exit_code != 0 {
        error make {msg: $"gh repo view failed in ($repo): ($repo_info.stderr | str trim)"}
    }
    let repo_json = try {
        $repo_info.stdout | from json
    } catch {|err| error make {msg: $"gh repo view returned invalid JSON in ($repo): ($err.msg)"} }
    let owner = $repo_json | get --optional owner.login
    let name = $repo_json | get --optional name
    if ($owner | is-empty) or ($name | is-empty) {
        error make {
            msg: $"gh repo view did not return an owner and repository name for ($repo)"
        }
    }

    $branches
    | uniq
    | chunks $BATCH
    | each {|batch|
        let fields = $batch | enumerate | each {|entry|
            let alias = 'b' + ($entry.index | into string)
            let branch = $entry.item | to json
            $alias + ': pullRequests(headRefName: ' + $branch + ', states: [OPEN, CLOSED, MERGED], first: 100) { nodes { headRefName headRefOid state isCrossRepository } pageInfo { hasNextPage } }'
        } | str join ' '
        let query = 'query { repository(owner: ' + ($owner | to json) + ', name: ' + ($name | to json) + ') { ' + $fields + ' } }'
        let response = gh-result api graphql -f $"query=($query)"
        if $response.exit_code != 0 {
            error make {msg: $"GitHub GraphQL request failed for ($repo): ($response.stderr | str trim)"}
        }
        let json = try { $response.stdout | from json } catch {|err|
            error make {msg: $"GitHub GraphQL returned invalid JSON for ($repo): ($err.msg)"}
        }
        let errors = $json | get --optional errors | default []
        if ($errors | is-not-empty) {
            let messages = $errors | each { get message } | str join '; '
            error make {msg: $"GitHub GraphQL returned errors for ($repo): ($messages)"}
        }
        let data = $json | get --optional data.repository
        if ($data | is-empty) {
            error make {msg: $"GitHub GraphQL returned no repository data for ($repo)"}
        }

        $batch
        | enumerate
        | each {|entry|
            let connection = $data | get ('b' + ($entry.index | into string))
            {
                branch: $entry.item
                prs: ($connection.nodes | default [])
                complete: (not ($connection.pageInfo.hasNextPage | default true))
            }
        }
    }
    | flatten
}

def status [wt: record]: nothing -> record {
    let result = (^timeout --kill-after '5s' '30s' git
        -C
        $wt.path
        status
        --porcelain
        --untracked-files=normal
        --ignored=matching | complete
    )
    if $result.exit_code != 0 {
        {
            clean: false
            error: (
                if $result.exit_code == 124 {
                    'git status timed out after 30 seconds'
                } else {
                    $result.stderr
                    | str trim
                    | default 'git status could not be verified'
                }
            )
        }
    } else {
        {
            clean: ($result.stdout | is-empty)
            error: ''
        }
    }
}

def classify [
    repo: string
    wts: list<record>
    prs: list<record>
    keep_paths: list<string>
]: nothing -> list<record> {
    $wts | each {|wt|
        let branch_prs = $prs | where branch == $wt.branch | get 0? | default null
        let current = current-worktree $wt.path
        let state = (
            if (path-protected $wt.path $keep_paths) { 'kept: explicitly protected' }
            else if $current { 'kept: current directory' }
            else if $wt.locked { 'kept: locked' }
            else if ($wt.branch | is-empty) { 'kept: detached HEAD' }
            else if $branch_prs == null { 'kept: no GitHub PR data' }
            else if not $branch_prs.complete { 'kept: PR results exceeded 100; branch status is incomplete' }
            else if ($branch_prs.prs | any {|pr| $pr.state == 'OPEN' }) { 'kept: branch has an open PR' }
            else {
                let finished = $branch_prs.prs | where {|pr| $pr.headRefName == $wt.branch and not $pr.isCrossRepository and $pr.state in ['CLOSED' 'MERGED'] }
                if ($finished | is-empty) { 'kept: no completed same-repository PR' } else {
                    let worktree_status = status $wt
                    if not $worktree_status.clean {
                        if ($worktree_status.error | is-empty) { 'kept: worktree has modified, untracked, or ignored files' } else { $"kept: git status failed: ($worktree_status.error)" }
                    } else {
                        let current_head_result = git-result -C $wt.path rev-parse HEAD
                        if $current_head_result.exit_code != 0 { 'kept: cannot read current HEAD' } else if ($current_head_result.stdout | str trim) != $wt.head { 'kept: HEAD changed during inspection' } else {
                            let branch_result = git-result -C $wt.path branch --show-current
                            if $branch_result.exit_code != 0 { 'kept: cannot read current branch' } else if ($branch_result.stdout | str trim) != $wt.branch { 'kept: branch changed during inspection' } else {
                                let exact_match = $finished | any {|pr| $wt.head == $pr.headRefOid }
                                if $exact_match { 'would remove: clean HEAD matches a completed same-repository PR' } else {
                                    let ancestry = $finished | each {|pr|
                                        let check = git-result -C $repo merge-base --is-ancestor $wt.head $pr.headRefOid
                                        {exit_code: $check.exit_code, error: ($check.stderr | str trim)}
                                    }
                                    if ($ancestry | any {|check| $check.exit_code == 0 }) { 'would remove: clean HEAD is contained in a completed same-repository PR' } else if ($ancestry | any {|check| $check.exit_code > 1 }) {
                                        let diagnostic = $ancestry | where exit_code > 1 | get error | where { is-not-empty } | str join '; '
                                        if ($diagnostic | is-empty) { 'kept: cannot verify PR ancestry' } else { $"kept: cannot verify PR ancestry: ($diagnostic)" }
                                    } else { 'kept: local HEAD is ahead of completed PRs' }
                                }
                            }
                        }
                    }
                }
            }
        )
        {path: $wt.path, head: $wt.head, branch: $wt.branch, state: $state}
    }
}

def remove-worktree [repo: string, planned: record, keep_paths: list<string>]: nothing -> record {
    if (path-protected $planned.path $keep_paths) { return {path: $planned.path, state: 'kept: explicitly protected'} }
    let live = worktrees $repo | where path == $planned.path | get 0? | default null
    if $live == null { return {path: $planned.path, state: 'kept: worktree changed or disappeared'} }
    if $live.locked or ($live.branch != $planned.branch) or ($live.head != $planned.head) {
        return {
            path: $planned.path
            state: 'kept: worktree metadata changed during cleanup'
        }
    }
    if (current-worktree $live.path) { return {path: $live.path, state: 'kept: current directory'} }

    let worktree_status = status $live
    if not $worktree_status.clean {
        let reason = if ($worktree_status.error | is-empty) { 'worktree became dirty' } else { $"git status failed: ($worktree_status.error)" }
        return {
            path: $live.path
            state: $"kept: ($reason)"
        }
    }
    let current_head = git-result -C $live.path rev-parse HEAD
    let current_branch = git-result -C $live.path branch --show-current
    if $current_head.exit_code != 0 or $current_branch.exit_code != 0 {
        return {
            path: $live.path
            state: 'kept: cannot recheck worktree HEAD and branch'
        }
    }
    if ($current_head.stdout | str trim) != $planned.head or ($current_branch.stdout | str trim) != $planned.branch {
        return {path: $live.path, state: 'kept: HEAD or branch changed during cleanup'}
    }

    let result = git-result -C $repo worktree remove $live.path
    if $result.exit_code != 0 {
        return {
            path: $live.path
            state: $"error: git worktree remove failed: ($result.stderr | str trim)"
        }
    }
    {path: $live.path, state: 'removed'}
}

def recheck-candidate [
    repo: string
    candidate: record
    current
    keep_paths: list<string>
]: nothing -> record {
    if $current == null {
        return {
            path: $candidate.path
            state: 'kept: worktree changed or disappeared during cleanup'
        }
    }
    if not ($current.state | str starts-with 'would remove:') {
        return $current
    }
    remove-worktree $repo $current $keep_paths
}

def process-repo [repo: string, dry_run: bool, keep_paths: list<string>]: nothing -> list<record> {
    let wts = worktrees $repo
    let branches = $wts | where {|wt| not $wt.locked and ($wt.branch | is-not-empty) and not (current-worktree $wt.path) and not (path-protected $wt.path $keep_paths) } | get branch | uniq
    if ($branches | is-empty) {
        return $wts | each {|wt|
            let state = if $wt.locked { 'kept: locked' } else if ($wt.branch | is-empty) { 'kept: detached HEAD' } else { 'kept: no eligible branches' }
            {path: $wt.path, state: $state}
        }
    }
    let prs = pull-requests $repo $branches
    let plans = classify $repo $wts $prs $keep_paths
    let candidates = $plans | where {|plan| $plan.state | str starts-with 'would remove:' }
    if $dry_run {
        return $plans
    }
    if ($candidates | is-empty) {
        return $plans
    }

    # Refresh GitHub state immediately before removal so a newly opened PR
    # cannot be hidden by an older closed PR for the same branch.
    let refreshed_prs = pull-requests $repo ($candidates | get branch | uniq)
    let refreshed = classify $repo (worktrees $repo) $refreshed_prs $keep_paths
    $plans | each {|plan|
        if not ($plan.state | str starts-with 'would remove:') {
            $plan
        } else {
            let current = $refreshed | where path == $plan.path | get 0? | default null
            recheck-candidate $repo $plan $current $keep_paths
        }
    }
}

def --wrapped main [...arguments: string] {
    if ($arguments | any {|arg| $arg in ['--help' '-h'] }) {
        print 'Usage: clean-worktrees.nu [--dry-run] [--keep PATH]... [REPOSITORY]...'
        print 'Without REPOSITORY, uses paths from ghq list -p.'
        print 'Status checks are limited to 30 seconds; unverified worktrees are kept.'
        return
    }
    let parsed = $arguments | reduce --fold {dry_run: false, keep_paths: [], repos: [], expect_keep: false} {|arg, state|
        if $state.expect_keep {
            if ($arg | str starts-with '-') { error make {msg: '--keep requires a path'} }
            {dry_run: $state.dry_run, keep_paths: ($state.keep_paths | append ($arg | path expand)), repos: $state.repos, expect_keep: false}
        } else if $arg == '--keep' {
            {dry_run: $state.dry_run, keep_paths: $state.keep_paths, repos: $state.repos, expect_keep: true}
        } else if $arg == '--dry-run' {
            {dry_run: true, keep_paths: $state.keep_paths, repos: $state.repos, expect_keep: false}
        } else if ($arg | str starts-with '-') {
            error make {msg: $"unknown option: ($arg)"}
        } else {
            {dry_run: $state.dry_run, keep_paths: $state.keep_paths, repos: ($state.repos | append ($arg | path expand)), expect_keep: false}
        }
    }
    if $parsed.expect_keep { error make {msg: '--keep requires a path'} }
    let keep_paths = $parsed.keep_paths
    let repos = if ($parsed.repos | is-empty) {
        let result = ^ghq list -p | complete
        if $result.exit_code != 0 {
            error make {msg: $"ghq list -p failed: ($result.stderr | str trim)"}
        }
        $result.stdout | lines | where { is-not-empty }
    } else {
        $parsed.repos
    }

    let output = $repos | each {|repo|
        try { process-repo $repo $parsed.dry_run $keep_paths } catch {|err|
            [{path: $repo, state: $"error: ($err | to nuon)"}]
        }
    } | flatten

    $output | each {|row| print $"($row.state)\t($row.path)" }
    let removed = $output | where state == 'removed' | length
    let planned = $output | where {|row| $row.state | str starts-with 'would remove:' } | length
    let kept = $output | where {|row| $row.state | str starts-with 'kept:' } | length
    let errors = $output | where {|row| $row.state | str starts-with 'error:' } | length
    print $"Removed: ($removed); would remove: ($planned); kept: ($kept); errors: ($errors)"
    if $errors > 0 { exit 1 }
}
