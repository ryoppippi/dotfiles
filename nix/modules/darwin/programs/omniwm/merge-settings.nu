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

        $merged | upsert $key (if $both_records { $old | deep-merge $new } else { $new })
    }
}

# Drop the settings the GUI owns from the piped template, so merging leaves the
# live file's values in place. `[routing] mode` selects between the macOS
# arrangement and the custom map that `monitorRoutingOverrides` describes, so it
# is monitor state as well — just nested rather than top-level.
def drop-gui-owned []: record -> record {
    let template = $in | reject --optional ...$GUI_OWNED_KEYS

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
    # template's monitor placeholders are all there is to write.
    let merged = if ($live | path exists) {
        open --raw $live | from toml | deep-merge ($template_settings | drop-gui-owned)
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
