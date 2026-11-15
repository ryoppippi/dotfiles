const PAGE_SIZE = 128

export def root-input [nodes: record, name: string] {
    let node = $nodes.root.inputs | get -o $name
    if $node == null { return null }
    $nodes | get $node
}

# Git's ~ operator follows first parents; date-filtered commit lists also
# include merged side branches whose trees can predate the current lock.
export def first-parent-expressions [revision: string]: nothing -> list<string> {
    0..($PAGE_SIZE - 1) | each {|offset| $"($revision)~($offset)" }
}

export def select-aged-commit [commits: list<any>, cutoff: datetime]: nothing -> record {
    let candidate = (
        $commits
        | where {|commit| $commit != null and ($commit.committedDate | into datetime) <= $cutoff }
        | get -o 0
    )
    if $candidate != null {
        return {
            status: 'found'
            sha: $candidate.oid
            date: ($candidate.committedDate | into datetime)
        }
    }
    if ($commits | any {|commit| $commit == null }) {
        return {status: 'none'}
    }
    {
        status: 'more'
        sha: ($commits | last | get oid)
    }
}

export def aged-commit [
    owner: string
    repo: string
    git_ref: string
    cutoff: datetime
]: nothing -> record {
    try {
        let ref = if ($git_ref | is-empty) { 'HEAD' } else { $git_ref }
        let tip = (
            gh api graphql
                -f 'query=query($owner:String!,$repo:String!,$ref:String!){repository(owner:$owner,name:$repo){object(expression:$ref){... on Commit{oid}}}}'
                -f $"owner=($owner)" -f $"repo=($repo)" -f $"ref=($ref)"
            | from json
            | get data.repository.object.oid
        )

        generate {|revision|
            let fields = (
                first-parent-expressions $revision
                | enumerate
                | each {|entry|
                    let expression = $entry.item | to json --raw
                    $"c($entry.index):object\(expression:($expression)){... on Commit{oid committedDate}}"
                }
                | str join ' '
            )
            let query = 'query($owner:String!,$repo:String!){repository(owner:$owner,name:$repo){' + $fields + '}}'
            let page = (
                gh api graphql -f $"query=($query)" -f $"owner=($owner)" -f $"repo=($repo)"
                | from json
                | get data.repository
            )
            let commits = 0..($PAGE_SIZE - 1) | each --keep-empty {|index| $page | get $"c($index)" }
            let result = select-aged-commit $commits $cutoff
            match $result.status {
                'more' => {next: $"($result.sha)~1"}
                _ => {out: $result}
            }
        } $tip | first
    } catch {
        {status: 'unavailable'}
    }
}
