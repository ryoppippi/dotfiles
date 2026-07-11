#!/usr/bin/env nix
#! nix shell --inputs-from . nixpkgs#nushell --command nu
# Ensure the TypeWhisper dictionary contains the custom terms and corrections
# defined in dictionary.json, via its local HTTP API.
#
# This is intentionally ADDITIVE, not a mirror. Activating a term pack
# materialises its terms and corrections into the same dictionary store this API
# exposes, and the API gives no way to tell pack-provided entries apart from
# user-defined ones. A wholesale replace would therefore wipe every activated
# term pack, so we only ever merge our own entries in and never delete. To
# remove an entry, delete it in the app (or with an explicit DELETE request).
#
# The TypeWhisper HTTP API must be enabled in Settings > Advanced. It binds to
# 127.0.0.1 only. Override the port with $TYPEWHISPER_PORT and the bearer token
# with $TYPEWHISPER_API_TOKEN when the defaults do not match.
#
# Usage:
#   ./dict-sync.nu             # sync from dictionary.json beside this script
#   ./dict-sync.nu other.json  # sync from a specific file
#   ./dict-sync.nu --strict    # exit non-zero when the API is unreachable

def script-dir [] {
	$env.CURRENT_FILE | path dirname
}

def auth-headers [] {
	mut headers = {Content-Type: 'application/json'}
	let token = ($env.TYPEWHISPER_API_TOKEN? | default '')
	if ($token | is-not-empty) {
		$headers = ($headers | insert Authorization $"Bearer ($token)")
	}
	$headers
}

def is-list-or-table [value: any] {
	($value | describe) =~ '^(list|table)'
}

def parse-dictionary [data: any, source: string] {
	if ($data | describe) !~ '^record' {
		error make {msg: $"($source): expected a JSON object"}
	}
	let terms = $data.terms?
	let corrections = $data.corrections?
	# open turns uniform JSON object arrays into tables, not lists.
	if not (is-list-or-table $terms) or not ($terms | all {|t| ($t | describe) == 'string'}) {
		error make {msg: $"($source): \"terms\" must be an array of strings"}
	}
	if not (is-list-or-table $corrections) {
		error make {
			msg: $"($source): \"corrections\" must be an array of \{original, replacement, caseSensitive\}"
		}
	}
	for c in $corrections {
		if ($c.original? | describe) != 'string' or ($c.replacement? | describe) != 'string' or ($c.caseSensitive? | describe) != 'bool' {
			error make {
				msg: $"($source): \"corrections\" must be an array of \{original, replacement, caseSensitive\}"
			}
		}
	}
	{terms: $terms, corrections: $corrections}
}

def --wrapped main [...args: string] {
	let strict = ($args | any {|a| $a == '--strict'})
	let file_arg = ($args | where {|a| not ($a | str starts-with '--')} | get --optional 0)
	let file = if $file_arg == null {
		(script-dir) | path join dictionary.json
	} else {
		$file_arg | path expand
	}

	let port = ($env.TYPEWHISPER_PORT? | default '8978')
	let root = $"http://localhost:($port)"
	let base = $"($root)/v1/dictionary"
	let headers = (auth-headers)

	let dict = (parse-dictionary (open $file) $file)

	# Optional dependency: skip quietly unless --strict
	let reachable = (try {
		let status = (http get --full --headers $headers $"($root)/v1/status")
		$status.status == 200
	} catch {
		false
	})

	if not $reachable {
		let message = $"typewhisper-dict-sync: API not reachable on :($port) — enable it in Settings > Advanced"
		if $strict {
			error make {msg: $message}
		}
		print --stderr $"($message) \(skipping\)"
		return
	}

	# terms: merge our terms in. replace:false keeps term-pack terms intact.
	http put --headers $headers --content-type application/json $"($base)/terms" {
		terms: $dict.terms
		replace: false
	}

	# corrections: add or update each one (PUT is idempotent per original).
	for correction in $dict.corrections {
		http put --headers $headers --content-type application/json $"($base)/corrections" $correction
	}

	print $"typewhisper-dict-sync: synced ($dict.terms | length) terms, ($dict.corrections | length) corrections from ($file)"
}
