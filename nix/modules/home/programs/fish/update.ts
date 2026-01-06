#!/usr/bin/env nix
/*
#! nix shell --inputs-from .# nixpkgs#bun -c bun
*/

/**
 * Update script for Fish plugins.
 *
 * Fetches the latest commits from GitHub repositories and updates
 * rev and sha256 hashes in default.nix.
 *
 * Usage:
 *   ./update.ts
 *   bun update.ts
 */

import { $ } from 'bun';
import { join } from 'node:path';

interface Plugin {
	name: string;
	owner: string;
	repo: string;
	currentRev: string;
}

const CONFIG_FILE = join(import.meta.dir, 'default.nix');

/**
 * Fetch the latest commit SHA from GitHub API.
 */
async function fetchLatestCommit(owner: string, repo: string): Promise<string> {
	const url = `https://api.github.com/repos/${owner}/${repo}/commits?per_page=1`;
	const response = await fetch(url);

	if (!response.ok) {
		throw new Error(`Failed to fetch ${owner}/${repo}: ${response.statusText}`);
	}

	const commits = (await response.json()) as Array<{ sha: string }>;
	return commits[0].sha;
}

/**
 * Fetch hash for a GitHub tarball using nix-prefetch-url.
 */
async function fetchHash(owner: string, repo: string, rev: string): Promise<string> {
	const url = `https://github.com/${owner}/${repo}/archive/${rev}.tar.gz`;
	const result = await $`nix-prefetch-url --unpack ${url}`.text();
	const hash = result.trim();

	// Convert to SRI format
	const sri = await $`nix hash to-sri --type sha256 ${hash}`.text();
	return sri.trim();
}

/**
 * Parse plugins from default.nix that use fetchFromGitHub.
 */
function parsePlugins(content: string): Plugin[] {
	const plugins: Plugin[] = [];

	// Match plugin blocks with fetchFromGitHub
	const pluginRegex =
		/name\s*=\s*"([^"]+)"[^}]*?src\s*=\s*pkgs\.fetchFromGitHub\s*\{[^}]*?owner\s*=\s*"([^"]+)"[^}]*?repo\s*=\s*"([^"]+)"[^}]*?rev\s*=\s*"([^"]+)"/gs;

	let match: RegExpExecArray | null;
	while ((match = pluginRegex.exec(content)) !== null) {
		const [, name, owner, repo, rev] = match;
		plugins.push({ name, owner, repo, currentRev: rev });
	}

	return plugins;
}

/**
 * Update a plugin's rev and sha256 in the content.
 */
function updatePluginInContent(
	content: string,
	plugin: Plugin,
	newRev: string,
	newHash: string,
): string {
	// Replace rev
	let updated = content.replace(
		new RegExp(`(name\\s*=\\s*"${plugin.name}"[^}]*?rev\\s*=\\s*")${plugin.currentRev}(")`),
		`$1${newRev}$2`,
	);

	// Replace sha256 (find the sha256 line after this plugin's owner/repo)
	const sha256Pattern = new RegExp(
		`(owner\\s*=\\s*"${plugin.owner}"[^}]*?repo\\s*=\\s*"${plugin.repo}"[^}]*?sha256\\s*=\\s*")sha256-[^"]+(")`,
		's',
	);

	updated = updated.replace(sha256Pattern, `$1${newHash}$2`);

	return updated;
}

// Main execution
async function main() {
	console.log('Fish Plugin Updater\n');
	console.log(`Reading ${CONFIG_FILE}...\n`);

	const content = await Bun.file(CONFIG_FILE).text();
	const plugins = parsePlugins(content);

	console.log(`Found ${plugins.length} GitHub-sourced plugins\n`);

	let updatedContent = content;
	let updateCount = 0;

	for (const plugin of plugins) {
		console.log(`Checking ${plugin.name} (${plugin.owner}/${plugin.repo})...`);
		console.log(`  Current: ${plugin.currentRev.substring(0, 8)}`);

		try {
			const latestRev = await fetchLatestCommit(plugin.owner, plugin.repo);

			if (latestRev === plugin.currentRev) {
				console.log(`  ✓ Already up to date\n`);
				continue;
			}

			console.log(`  Latest:  ${latestRev.substring(0, 8)}`);
			console.log(`  Fetching hash...`);

			const newHash = await fetchHash(plugin.owner, plugin.repo, latestRev);
			console.log(`  Hash: ${newHash}`);

			updatedContent = updatePluginInContent(updatedContent, plugin, latestRev, newHash);

			console.log(`  ✓ Updated\n`);
			updateCount++;
		} catch (error) {
			console.error(`  ✗ Error: ${error.message}\n`);
		}
	}

	if (updateCount === 0) {
		console.log('✓ All plugins are up to date!');
		return;
	}

	await Bun.write(CONFIG_FILE, updatedContent);

	console.log(`✓ Done! Updated ${updateCount} plugin(s) in default.nix`);
	console.log("\nRun 'nix run .#switch' to apply changes.");
}

main();
