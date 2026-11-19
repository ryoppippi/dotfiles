#!/usr/bin/env nu

# PreToolUse hook for Claude Code and Codex: deny a Bash command that posts a
# GitHub comment, review, or reply without the `leaving-pr-comments`
# attribution, or opens a pull request without the `create-pr` one. Agents do
# both as a step of other work and forget the skill, so recall alone does not
# hold.
#
# The command text is matched, not parsed: heredocs and `$(…)` make shell
# parsing fragile, and a body written inline or through a heredoc is part of
# the text anyway. A body read from a file named on the command line is opened.
# Any other source is denied, and the message says how to pass the body.
#
# Exit 2 denies in both harnesses; any other failure is non-blocking.
#
# Usage: nu --stdin require-attribution.nu < hook-input.json

const COMMENT_NOTE = 'responding on behalf of'
const PR_NOTE = 'opened this on behalf of'
const VERBATIM = 'GH_COMMENT_VERBATIM=1'
# `gh` where a command starts, optionally after env assignments, so a search
# for the text `gh pr comment` is not mistaken for running it.
const GH = '(?m)(?:^|[;&|(]|\$\()\s*(?:\w+=\S*\s+)*gh\s+'
const API_WRITE = '\s(?:(?:-X|--method)\s*(?:POST|PATCH|PUT)\b|(?:-f|-F|--field|--raw-field|--input)(?:\s|=))'
const API_READ = '\s(?:-X|--method)\s*GET\b'
const BODY_HINT = 'inline or with --body-file <path> (a body in a shell variable or piped from another command cannot be checked)'
const COMMENT_REASON = $'This command posts a GitHub comment, review, or reply without the attribution note. Load the `leaving-pr-comments` skill and add its note to the body, ($BODY_HINT). Only for text the user explicitly asked to post verbatim, or a bare bot command such as `@coderabbitai review`, prefix the command with ($VERBATIM).'
const PR_REASON = $'This command opens a pull request without the attribution note. Load the `create-pr` skill and follow it for the title and body, passing the body ($BODY_HINT). Only for a body the user supplied verbatim, prefix the command with ($VERBATIM).'

def api-writes []: string -> bool {
    let command = $in
    ($command =~ ($GH + 'api\b')) and ($command =~ $API_WRITE) and not ($command =~ $API_READ)
}

def posts-comment []: string -> bool {
    let command = $in

    let comment = $command =~ ($GH + '(?:pr|issue)\s+comment\b')
    let review = (
        ($command =~ ($GH + 'pr\s+review\b'))
        and ($command =~ '\s(?:-b|--body|-F|--body-file)(?:\s|=)')
    )
    let api = (
        ($command =~ '/(?:comments|replies|reviews)(?:/\d+)?(?:[\s?''"]|$)')
        and ($command | api-writes)
    )

    $comment or $review or $api
}

def opens-pr []: string -> bool {
    let command = $in

    let create = $command =~ ($GH + 'pr\s+create\b')
    let api = ($command =~ '/pulls(?:[\s?''"]|$)') and ($command | api-writes)

    $create or $api
}

def body-files [cwd: string]: string -> list<string> {
    $in
    | parse --regex '(?:--body-file|--input|-F|--field)[ =]["'']?(?<arg>[^\s"'']+)'
    | get arg
    | each {|arg|
        if ($arg | str contains '=') {
            $arg | parse --regex '^body=@(?<path>.+)$' | get --optional path.0
        } else {
            $arg
        }
    }
    | compact
    | where $it != '-'
    | each {|file|
        if ($file | str starts-with '/') or ($file | str starts-with '~') {
            $file | path expand
        } else {
            $cwd | path join $file
        }
    }
}

def has-note [note: string, cwd: string]: string -> bool {
    let command = $in

    (
        ($command | str contains $note)
        or (
            $command
            | body-files $cwd
            | where { path exists }
            | any { open --raw | str contains $note }
        )
    )
}

def main []: string -> nothing {
    let input = $in | from json
    let command = $input.tool_input?.command? | default ''
    let cwd = $input.cwd? | default $env.PWD

    if ($command | str contains $VERBATIM) {
        return
    }

    let reason = if ($command | posts-comment) and not ($command | has-note $COMMENT_NOTE $cwd) {
        $COMMENT_REASON
    } else if ($command | opens-pr) and not ($command | has-note $PR_NOTE $cwd) {
        $PR_REASON
    }

    if $reason != null {
        print --stderr $reason
        exit 2
    }
}
