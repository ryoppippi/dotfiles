#!/usr/bin/env nu

# Restore the repository's OmniWM settings template over the live file while
# leaving the monitor settings alone.
#
# OmniWM has no include mechanism — `~/.config/omniwm/settings.toml` is its only
# settings source, and the app rewrites that file wholesale whenever the GUI
# saves — so activation has to copy the whole template over it. Monitor settings
# are keyed by physical display UUID, which makes them a description of the
# machine and the desk it sits on rather than of this configuration: the
# external display differs between home and the office, so a committed UUID is
# guaranteed to be wrong in one of the two. Those keys stay GUI-owned and are
# layered back on top of the template here.
#
# Usage: merge-settings.nu <template> <live>

# Top-level settings the GUI owns. Everything else comes from the template.
const GUI_OWNED_KEYS = [
    monitorBarOverrides
    monitorDwindleOverrides
    monitorGapOverrides
    monitorNiriOverrides
    monitorOrientationOverrides
    monitorRoutingOverrides
]

# Copy the GUI-owned top-level keys of $live_settings onto the piped template.
def preserve-monitor-keys [live_settings: record]: record -> record {
    let template = $in

    $GUI_OWNED_KEYS
    | where {|key| $key in $live_settings }
    | reduce --fold $template {|key, merged| $merged | upsert $key ($live_settings | get $key) }
}

# `[routing] mode` selects between the macOS arrangement and the custom map that
# `monitorRoutingOverrides` describes, so it is monitor state as well — just
# nested rather than top-level.
def preserve-routing-mode [live_settings: record]: record -> record {
    let template = $in
    let mode = $live_settings | get --optional routing.mode

    if $mode == null { $template } else {
        $template | upsert routing.mode $mode
    }
}

def main [template: path, live: path]: nothing -> nothing {
    if not ($template | path exists) {
        error make {msg: $"OmniWM settings template is missing: ($template)"}
    }

    let settings = open --raw $template | from toml

    # A first-ever activation has no live file to preserve anything from.
    let merged = if ($live | path exists) {
        let live_settings = open --raw $live | from toml

        $settings
        | preserve-monitor-keys $live_settings
        | preserve-routing-mode $live_settings
    } else {
        $settings
    }

    mkdir ($live | path dirname)

    # OmniWM reads this file while running, so swap it in whole rather than
    # letting the app observe a half-written one.
    let staged = $live | path parse | upsert extension 'toml.nix-tmp' | path join
    $merged | to toml | save --force $staged
    mv --force $staged $live
}
