#!/usr/bin/env nu

# PreToolUse hook for Claude Code and Codex: deny a Bash command that posts a
# GitHub comment, review, or reply without the `leaving-pr-comments`
# attribution. Agents post comments as a step of other work and forget the
# skill, so recall alone does not hold.
#
# The command text is matched, not parsed: heredocs and `$(…)` make shell
# parsing fragile, and a body written inline or through a heredoc is part of
# the text anyway. A body read from a file named on the command line is opened.
# Any other source is denied, and the message says how to pass the body.
#
# Exit 2 denies in both harnesses; any other failure is non-blocking.
#
# Usage: nu --stdin require-comment-attribution.nu < hook-input.json

const ATTRIBUTION = 'responding on behalf of'
const VERBATIM = 'GH_COMMENT_VERBATIM=1'
# `gh` where a command starts, optionally after env assignments, so a search
# for the text `gh pr comment` is not mistaken for running it.
const GH = '(?m)(?:^|[;&|(]|\$\()\s*(?:\w+=\S*\s+)*gh\s+'
const REASON = 'This command posts a GitHub comment, review, or reply without the attribution note. Load the `leaving-pr-comments` skill and add its note to the body, inline or with --body-file <path> (a body in a shell variable or piped from another command cannot be checked). Only for text the user explicitly asked to post verbatim, or a bare bot command such as `@coderabbitai review`, prefix the command with GH_COMMENT_VERBATIM=1.'

def posts-comment []: string -> bool {
    let command = $in

    let comment = $command =~ ($GH + '(?:pr|issue)\s+comment\b')
    let review = (
        ($command =~ ($GH + 'pr\s+review\b'))
        and ($command =~ '\s(?:-b|--body|-F|--body-file)(?:\s|=)')
    )
    let api = (
        ($command =~ ($GH + 'api\b'))
        and ($command =~ '/(?:comments|replies|reviews)(?:/\d+)?(?:[\s?''"]|$)')
        and ($command =~ '\s(?:(?:-X|--method)\s*(?:POST|PATCH|PUT)\b|(?:-f|-F|--field|--raw-field|--input)(?:\s|=))')
        and not ($command =~ '\s(?:-X|--method)\s*GET\b')
    )

    $comment or $review or $api
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

def has-attribution [cwd: string]: string -> bool {
    let command = $in

    (
        ($command | str contains $ATTRIBUTION)
        or (
            $command
            | body-files $cwd
            | where { path exists }
            | any { open --raw | str contains $ATTRIBUTION }
        )
    )
}

def main []: string -> nothing {
    let input = $in | from json
    let command = $input.tool_input?.command? | default ''
    let cwd = $input.cwd? | default $env.PWD

    let allowed = (
        not ($command | posts-comment)
        or ($command | str contains $VERBATIM)
        or ($command | has-attribution $cwd)
    )

    if not $allowed {
        print --stderr $REASON
        exit 2
    }
}
