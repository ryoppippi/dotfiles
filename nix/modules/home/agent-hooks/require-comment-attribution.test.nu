#!/usr/bin/env nu

# Usage: require-comment-attribution.test.nu

const HOOK = path self require-comment-attribution.nu
const NOTE = "> [!NOTE]\n> 🤖 **Opus responding on behalf of ryoppippi**\n\nFixed."

def run-hook [command: string, cwd: string]: nothing -> int {
    {
        tool_name: 'Bash'
        tool_input: {command: $command}
        cwd: $cwd
    }
    | to json
    | ^$nu.current-exe --no-config-file --stdin $HOOK
    | complete
    | get exit_code
}

def main [] {
    let dir = mktemp --directory
    $NOTE | save ($dir | path join 'with-note.md')
    'Fixed.' | save ($dir | path join 'without-note.md')

    let cases = [
        [command, expected];
        [$"gh api repos/o/r/pulls/1/comments/2/replies -f body='Fixed in abc'", 2]
        [$"gh api repos/o/r/pulls/1/comments/2/replies -f body='($NOTE)'", 0]
        ["gh pr comment 1 --body 'LGTM'", 2]
        ["gh pr comment --body '@codesmith prove it'", 2]
        ["GH_COMMENT_VERBATIM=1 gh pr comment --body '@codesmith prove it'", 0]
        ["gh pr review 1 --comment -b 'x'", 2]
        ["gh pr review 1 --approve", 0]
        ["gh issue comment 1 -F without-note.md", 2]
        ["gh issue comment 1 -F with-note.md", 0]
        [$"gh api repos/o/r/issues/1/comments -F body=@($dir)/with-note.md", 0]
        ["gh api repos/o/r/pulls/comments/2 -X PATCH -f body=x", 2]
        ["gh api repos/o/r/pulls/1/comments", 0]
        ["gh api --paginate repos/o/r/pulls/1/comments --jq '.[].body'", 0]
        ["gh api -X DELETE repos/o/r/pulls/comments/2", 0]
        ["gh api -X GET repos/o/r/pulls/1/reviews -f per_page=100", 0]
        ["gh pr comment 1 --body \"$BODY\"", 2]
        ["cat body.md | gh pr comment 1 --body-file -", 2]
        [$"gh pr comment 1 --body-file - <<'EOF'\n($NOTE)\nEOF", 0]
        ["git push && gh pr comment 1 --body 'done'", 2]
        ["rg 'gh pr comment' agents", 0]
        ["gh pr edit 1 --body 'new description'", 0]
        ["gh pr create --title t --body 'description'", 0]
        ["git status", 0]
    ]

    let failures = $cases
    | insert actual {|case| run-hook $case.command $dir }
    | where {|case| $case.actual != $case.expected }

    rm --recursive $dir

    if ($failures | is-not-empty) {
        print ($failures | table --expand)
        error make {msg: $"($failures | length) of ($cases | length) cases failed"}
    }

    let malformed = 'not json' | ^$nu.current-exe --no-config-file --stdin $HOOK | complete
    if $malformed.exit_code in [0 2] {
        error make {
            msg: $"malformed input exited ($malformed.exit_code); it must be non-blocking but visible"
        }
    }

    print $"all ($cases | length) cases passed"
}
