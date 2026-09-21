#!/usr/bin/env nu

# Carry OmniWM's display-dependent settings across a Home Manager activation.
#
# The omniwm.nix module treats Nix as the sole owner of settings.toml: it writes
# the whole file on activation and keeps the previous one as settings.toml.bak.
# That is the right model for everything this repository describes, but a few
# top-level keys describe the machine and the desk it sits on rather than this
# configuration. They are keyed by physical display UUID, and the external
# display differs between home and the office, so a committed value is
# guaranteed to be wrong in one of the two — see the README.
#
# `save` runs before the module writes and `restore` after, so the keys survive
# a switch and stay configurable from the GUI. Snapshotting up front rather than
# reading settings.toml.bak afterwards is what makes this correct when the
# module finds the file already current and skips its write: the .bak is then
# left over from an earlier activation and would reinstate a stale arrangement.
#
# Usage: display-state.nu save <live> <state>
#        display-state.nu restore <state> <live>

# `routing` holds `arrangements`, the map of which display sits next to which,
# and `mode`, which selects between that map and the macOS one. Both belong to
# the desk. The whole table is display state, so it moves as one key.
const DISPLAY_OWNED_KEYS = [
    monitorBarOverrides
    monitorDwindleOverrides
    monitorGapOverrides
    monitorNiriOverrides
    monitorOrientationOverrides
    routing
]

# OmniWM reads settings.toml while running, so swap the file in whole rather
# than letting the app observe a half-written one.
def save-atomically [target: path]: any -> nothing {
    let staged = $target | path parse | upsert extension 'toml.nix-tmp' | path join
    mkdir ($target | path dirname)
    $in | to toml | save --force $staged
    mv --force $staged $target
}

# Snapshot the display-owned keys OmniWM currently holds. A missing live file
# means there is nothing to preserve yet; the existing snapshot, if any, is left
# alone rather than replaced with an empty one.
def "main save" [live: path, state: path]: nothing -> nothing {
    if not ($live | path exists) { return }

    let settings = open --raw $live | from toml
    let present = $settings | columns

    $DISPLAY_OWNED_KEYS
    | where $it in $present
    | reduce --fold {} {|key, acc| $acc | upsert $key ($settings | get $key) }
    | save-atomically $state
}

# Layer the snapshot back over the file the module just wrote. A shallow merge
# is what is wanted: each of these keys is replaced whole, never merged into.
def "main restore" [state: path, live: path]: nothing -> nothing {
    if not (($state | path exists) and ($live | path exists)) { return }

    let saved = open --raw $state | from toml
    if ($saved | is-empty) { return }

    open --raw $live | from toml | merge $saved | save-atomically $live
}

def main [] {
    error make {msg: "display-state.nu: expected `save` or `restore`"}
}
