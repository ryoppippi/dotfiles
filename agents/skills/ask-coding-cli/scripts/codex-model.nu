#!/usr/bin/env nix
#! nix shell nixpkgs#nushell --command nu

# Print the newest Codex model slug of one family (luna, sol, ...), read from
# Codex's live model catalog so callers never pin a name that goes stale.
#
# Usage: codex-model.nu [family]   # defaults to luna

def main [family: string = 'luna']: nothing -> string {
    ^codex debug models
    | from json
    | get models
    # Hidden entries are internal models the picker does not offer.
    | where visibility == 'list' and ($it.slug =~ $'^gpt-.*-($family)$')
    # `priority` is the picker's order, newest first.
    | sort-by priority
    | get --optional 0.slug
    | default { error make { msg: $'no Codex model found for family "($family)"' } }
}
