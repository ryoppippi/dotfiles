# browser-open — the $BROWSER hook.
#
# CLIs that open URLs themselves (`gh pr view --web`, ...) should land in a cmux
# browser split next to the calling terminal. cmux's own
# `interceptTerminalOpenCommandInCmuxBrowser` setting only catches links printed
# to the terminal and `open` typed at the prompt, so a CLI that execs `open`
# itself slips past it — hence this hook.

# CMUX_SURFACE_ID is exported only to processes cmux itself spawned, so it
# answers "is the user driving this from cmux right now?". Without it a split
# would land in an unrelated window, or cmux may not even be running.
def in-cmux [] {
	$env.CMUX_SURFACE_ID? | default "" | is-not-empty
}

# Prefer the CLI bundled with the running cmux app so we drive the same build
# that owns this surface; fall back to whatever is on PATH.
def cmux-cli [] {
	let bundled = ($env.CMUX_BUNDLED_CLI_PATH? | default "")

	if ($bundled | is-not-empty) and ($bundled | path exists) {
		$bundled
	} else {
		which cmux | get --optional 0 | get --optional path
	}
}

def system-open [] {
	if $nu.os-info.name == "macos" { "/usr/bin/open" } else { "xdg-open" }
}

def --wrapped main [...urls] {
	if ($urls | is-empty) {
		print --stderr "usage: browser-open <url> [url...]"
		exit 2
	}

	let cli = (cmux-cli)
	let opener = (system-open)

	for url in $urls {
		if (in-cmux) and ($cli != null) {
			let result = (^$cli browser open-split $url --focus false | complete)

			if $result.exit_code == 0 {
				continue
			}

			# Say why cmux refused before falling back, otherwise a dead socket
			# looks like the split silently never happening.
			print --stderr ($result.stderr | str trim)
		}

		^$opener $url
	}
}
