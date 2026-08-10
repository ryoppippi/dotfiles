#!/usr/bin/env nu

# Overlay the repository's Codex settings onto the live config.toml, keeping
# every key the ChatGPT desktop app writes there itself.
#
# Codex reads a single config file and the app stores its own runtime wiring in
# it: the bundled plugin registrations, the `node_repl` and `computer-use` MCP
# servers, and the environment those need. Copying the template over that file
# wholesale strips the wiring, which disables browser use and computer use
# until the app happens to write it back. So the template contributes only the
# keys it actually defines, and the rest of the live file is left alone.
#
# Usage: merge-config.nu <template> <live>

# Overlay $overlay onto the piped record, recursing into keys both sides hold as
# records. Leaf values from $overlay win; keys absent from it keep their live
# value. Recursing is what lets a template key sit beside an app-owned one
# within the same table — `shell_environment_policy.inherit` beside
# `shell_environment_policy.set`, or the template's plugin beside the bundled
# ones — instead of the whole table being replaced.
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

def main [template: path, live: path]: nothing -> nothing {
    if not ($template | path exists) {
        error make {msg: $"Codex config template is missing: ($template)"}
    }

    let template_settings = open --raw $template | from toml

    # A first-ever activation has no live file to preserve anything from.
    let merged = if ($live | path exists) {
        open --raw $live | from toml | deep-merge $template_settings
    } else {
        $template_settings
    }

    mkdir ($live | path dirname)

    # Codex reads this file while running, so swap it in whole rather than
    # letting the app observe a half-written one.
    let staged = $live | path parse | upsert extension 'toml.nix-tmp' | path join
    $merged | to toml | save --force $staged
    mv --force $staged $live
}
