#!/usr/bin/env nix
#! nix shell --inputs-from ../../../../.. nixpkgs#nushell nixpkgs#nix nixpkgs#gh --command nu
# Update Fish plugin rev/sha256 in default.nix from the latest GitHub commits.
#
# Usage:
#   ./update.nu

def script-dir [] {
	$env.CURRENT_FILE | path dirname
}

def fetch-latest-commit [owner: string, repo: string] {
	# gh uses the authenticated token, so we avoid unauthenticated rate limits.
	let result = (^gh api $"repos/($owner)/($repo)/commits?per_page=1" | complete)
	if $result.exit_code != 0 {
		error make {msg: $"Failed to fetch ($owner)/($repo): ($result.stderr | str trim)"}
	}
	$result.stdout | from json | get 0.sha
}

def fetch-hash [owner: string, repo: string, rev: string] {
	let url = $"https://github.com/($owner)/($repo)/archive/($rev).tar.gz"
	let hash = (^nix-prefetch-url --unpack $url | str trim)
	^nix hash to-sri --type sha256 $hash | str trim
}

# Plugins that use pkgs.fetchFromGitHub in default.nix.
# [^}]*? keeps each match inside a single attrset (same as the old TS script).
def parse-plugins [content: string] {
	$content
	| parse --regex 'name\s*=\s*"(?P<name>[^"]+)"[^}]*?src\s*=\s*pkgs\.fetchFromGitHub\s*\{[^}]*?owner\s*=\s*"(?P<owner>[^"]+)"[^}]*?repo\s*=\s*"(?P<repo>[^"]+)"[^}]*?rev\s*=\s*"(?P<rev>[^"]+)"[^}]*?sha256\s*=\s*"(?P<sha256>[^"]+)"'
	| rename name owner repo current_rev current_sha256
}

def main [] {
	let config_file = ((script-dir) | path join default.nix)
	print "Fish Plugin Updater\n"
	print $"Reading ($config_file)...\n"

	mut content = (open --raw $config_file | decode utf-8)
	let plugins = (parse-plugins $content)
	print $"Found ($plugins | length) GitHub-sourced plugins\n"

	mut update_count = 0

	for plugin in $plugins {
		print $"Checking ($plugin.name) — ($plugin.owner)/($plugin.repo)..."
		print $"  Current: ($plugin.current_rev | str substring 0..8)"

		try {
			let latest_rev = (fetch-latest-commit $plugin.owner $plugin.repo)

			if $latest_rev == $plugin.current_rev {
				print "  ✓ Already up to date\n"
				continue
			}

			print $"  Latest:  ($latest_rev | str substring 0..8)"
			print "  Fetching hash..."

			let new_hash = (fetch-hash $plugin.owner $plugin.repo $latest_rev)
			print $"  Hash: ($new_hash)"

			# Full git SHAs and SRI hashes are unique in this file.
			$content = (
				$content
				| str replace $plugin.current_rev $latest_rev
				| str replace $plugin.current_sha256 $new_hash
			)
			$update_count = $update_count + 1
			print "  ✓ Updated\n"
		} catch {|err|
			print --stderr $"  ✗ Error: ($err.msg)\n"
		}
	}

	if $update_count == 0 {
		print "✓ All plugins are up to date!"
		return
	}

	$content | save --force $config_file
	print $"✓ Done! Updated ($update_count) plugin\(s\) in default.nix"
	print "\nRun 'nix run .#switch' to apply changes."
}
