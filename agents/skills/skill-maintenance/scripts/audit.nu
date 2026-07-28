#!/usr/bin/env nu

# Audit every local skill for the mechanical, countable parts of skill-creator's
# conventions: SKILL.md length, frontmatter name/description length, and whether
# references/ and scripts/ exist. Returns one row per skill and flags violations
# in the `flags` column. Judgement-based checks (duplication, doc links,
# repo-file pointers) are NOT covered here — see references/audit-checks.md.

# Thresholds. Hard limits (marked `!` in output) come from Anthropic's
# frontmatter validation; soft limits encode skill-creator guidance.
# See references/audit-checks.md.
const LINE_SOFT = 150 # consider splitting into references/ above this
const LINE_HARD = 500 # Anthropic hard ceiling for the SKILL.md body
const NAME_MAX = 64 # frontmatter name hard limit
const DESC_MAX = 1024 # frontmatter description hard limit
const DESC_SOFT = 350 # keep descriptions tight (~20-35 words); flag above this

# The lines between the first two `---` fences, or [] when there is no
# frontmatter block. Read as raw text rather than YAML: a description may
# contain `: `, which is not a valid plain scalar, and the length of the raw
# value is what the limits apply to.
def frontmatter [text: string]: nothing -> list<string> {
    let lines = $text | lines
    if ($lines | first | default '') != '---' {
        return []
    }
    let body = $lines | skip 1
    let close = $body | enumerate | where item == '---' | get --optional 0.index
    if $close == null { [] } else {
        $body | first $close
    }
}

# The value of a single-line `key: value` entry, '' when absent.
def frontmatter-value [lines: list<string>, key: string]: nothing -> string {
    $lines
    | where {|line| $line starts-with $"($key):" }
    | get --optional 0
    | default ''
    | str replace --regex $"^($key): *" ''
}

# Every threshold violation for one skill, as a list of short labels.
def flags-for [lines: int, name_len: int, desc_len: int]: nothing -> list<string> {
    [
        (if $lines > $LINE_HARD { $"lines>($LINE_HARD)!" })
        (
            if $lines > $LINE_SOFT and $lines <= $LINE_HARD { $"lines>($LINE_SOFT)" }
        )
        (if $name_len == 0 { 'name-missing!' })
        (if $name_len > $NAME_MAX { $"name>($NAME_MAX)!" })
        (if $desc_len == 0 { 'desc-missing!' })
        (if $desc_len > $DESC_MAX { $"desc>($DESC_MAX)!" })
        (
            if $desc_len > $DESC_SOFT and $desc_len <= $DESC_MAX { $"desc>($DESC_SOFT)" }
        )
    ]
    | compact
}

def audit-skill [dir: path]: nothing -> record {
    let skill = $dir | path basename
    let file = $dir | path join SKILL.md

    if not ($file | path exists) {
        return {
            skill: $skill
            lines: null
            name: null
            desc: null
            refs: null
            scrp: null
            flags: ['no-SKILL.md!']
        }
    }

    let text = open --raw $file
    let fm = frontmatter $text
    # Graphemes, not bytes: the limits are character counts, and descriptions
    # here contain em dashes.
    let name_len = frontmatter-value $fm name | str length --grapheme-clusters
    let desc_len = frontmatter-value $fm description | str length --grapheme-clusters
    let lines = $text | lines | length

    {
        skill: $skill
        lines: $lines
        name: $name_len
        desc: $desc_len
        refs: ($dir | path join references | path exists)
        scrp: ($dir | path join scripts | path exists)
        flags: (flags-for $lines $name_len $desc_len)
    }
}

# Audit every skill directory under skills_dir.
#
# skills_dir defaults to the agents/skills directory this script lives under.
# The report goes to stdout and the summary to stderr. Pass --json to get the
# rows as data instead: a table cannot survive the process boundary, so
# piping the rendered report into a filter would only ever see text.
def main [skills_dir?: path, --json]: nothing -> string {
    let dir = $skills_dir | default (
        $env.CURRENT_FILE
        | path dirname
        | path join .. ..
        | path expand
    )

    if not ($dir | path exists) {
        error make {msg: $"Skills directory not found: ($dir)"}
    }

    let rows = ls $dir | where type == dir | get name | each {|d| audit-skill $d }
    let issues = $rows | get flags | flatten | length

    let summary = if $issues > 0 {
        $"Flagged ($issues) item\(s\). '!' = hard violation, others = review against references/audit-checks.md."
    } else {
        'No mechanical violations. Still run the judgement checks in references/audit-checks.md.'
    }
    print --stderr $summary

    if $json {
        return ($rows | to json)
    }

    # Render here rather than leaving it to the caller: at the default terminal
    # width nu drops the rightmost columns, and `flags` is the whole point.
    $rows
    | update flags {|row| $row.flags | str join ' ' }
    | update refs {|row| if $row.refs { 'yes' } }
    | update scrp {|row| if $row.scrp { 'yes' } }
    | table --index false --width 110
}
