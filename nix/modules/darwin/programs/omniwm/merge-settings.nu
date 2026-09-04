#!/usr/bin/env nu

# Overlay the repository's OmniWM settings onto the live file, keeping the
# monitor settings and anything else the app owns.
#
# OmniWM has no include mechanism — `~/.config/omniwm/settings.toml` is its only
# settings source, and the app rewrites that file wholesale whenever the GUI
# saves — so activation has to write the whole file back. It contributes only
# the keys the template actually defines, though: a key the app writes and the
# template says nothing about is left alone rather than dropped.
#
# The monitor settings are the one case where the template does define a key and
# still loses. They are keyed by physical display UUID, which makes them a
# description of the machine and the desk it sits on rather than of this
# configuration: the external display differs between home and the office, so a
# committed UUID is guaranteed to be wrong in one of the two. The template
# carries empty placeholders for them, so they have to be dropped from the
# overlay explicitly for the live values to stand.
#
# Hotkeys are merged entry by entry rather than as one array. OmniWM validates
# the hotkey list strictly — an id it does not know, or one it expects and does
# not find, makes it reject the whole file and keep running on whatever it
# loaded last, with nothing more than a log line to show for it. A committed
# copy of the full list therefore breaks on every release that renames or adds
# an action. Taking the live list, which the app itself keeps current, and
# overriding only the bindings the template names keeps the file exactly as
# valid as the app left it.
#
# Usage: merge-settings.nu <template> <live>

# Top-level settings the GUI owns. Everything else the template defines wins.
const GUI_OWNED_KEYS = [
    monitorBarOverrides
    monitorDwindleOverrides
    monitorGapOverrides
    monitorNiriOverrides
    monitorOrientationOverrides
    monitorRoutingOverrides
]

# Top-level settings the app owns. `schemaVersion` describes the layout of the
# live file, which the app migrates in place; a template value would claim a
# schema the rest of the file may not follow.
const APP_OWNED_KEYS = [schemaVersion]

# A list of records describes itself as `table<...>`, not `list<...>`, so both
# spellings have to count as a list.
def is-list []: any -> bool {
    let type = $in | describe
    ($type | str starts-with 'list') or ($type | str starts-with 'table')
}

# Override the bindings of the piped live hotkey list with those in $overlay,
# matched by id. Ids the live list lacks are reported and skipped rather than
# appended, because the app rejects a list holding an id it does not know.
def merge-hotkeys [overlay: list<any>]: list<any> -> list<any> {
    let live = $in
    let live_ids = $live | get id

    let unknown = $overlay | where id not-in $live_ids | get id
    if ($unknown | is-not-empty) {
        print --stderr $"OmniWM hotkey ids not in this build, bindings skipped: ($unknown | str join ', ')"
    }

    $live | each {|entry|
        let override = $overlay | where id == $entry.id
        if ($override | is-empty) { $entry } else { $entry | merge ($override | first) }
    }
}

# Overlay $overlay onto the piped record, recursing into keys both sides hold as
# records. Leaf values from $overlay win; keys absent from it keep their live
# value. Recursing is what lets a template key sit beside an app-owned one
# within the same table instead of the whole table being replaced.
def deep-merge [overlay: record]: record -> record {
    let base = $in

    $overlay
    | columns
    | reduce --fold $base {|key, merged|
        let new = $overlay | get $key
        let old = $merged | get --optional $key

        let both_records = (
            ($old | describe | str starts-with 'record')
            and ($new | describe | str starts-with 'record')
        )
        let both_hotkey_lists = (
            $key == 'hotkeys'
            and ($old | is-list)
            and ($new | is-list)
        )

        let value = if $both_records {
            $old | deep-merge $new
        } else if $both_hotkey_lists {
            $old | merge-hotkeys $new
        } else {
            $new
        }

        $merged | upsert $key $value
    }
}

# Drop the settings the GUI or the app owns from the piped template, so merging
# leaves the live file's values in place. `[routing] mode` selects between the
# macOS arrangement and the custom map that `monitorRoutingOverrides` describes,
# so it is monitor state as well — just nested rather than top-level.
def drop-owned []: record -> record {
    let template = $in | reject --optional ...$GUI_OWNED_KEYS ...$APP_OWNED_KEYS

    if 'routing' in $template {
        $template | update routing { reject --optional mode }
    } else {
        $template
    }
}

def main [template: path, live: path]: nothing -> nothing {
    if not ($template | path exists) {
        error make {msg: $"OmniWM settings template is missing: ($template)"}
    }

    let template_settings = open --raw $template | from toml

    # A first-ever activation has no live file to preserve anything from, so the
    # template's monitor placeholders are all there is to write. Its partial
    # hotkey list will not pass validation either, so the app starts on its
    # defaults and writes a complete file; the next activation merges onto that.
    let merged = if ($live | path exists) {
        open --raw $live | from toml | deep-merge ($template_settings | drop-owned)
    } else {
        $template_settings
    }

    mkdir ($live | path dirname)

    # OmniWM reads this file while running, so swap it in whole rather than
    # letting the app observe a half-written one.
    let staged = $live | path parse | upsert extension 'toml.nix-tmp' | path join
    $merged | to toml | save --force $staged
    mv --force $staged $live
}
