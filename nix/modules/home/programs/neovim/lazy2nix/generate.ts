#!/usr/bin/env bun
/**
 * lazy2nix — generate Nix expressions from lazy.nvim's runtime state.
 *
 * Reads the resolved plugin table (via dump.lua in a headless Neovim) and
 * lazy-lock.json, then writes two files next to this script:
 *
 * - nixpkgs-plugins.nix: plugins whose upstream repo matches a nixpkgs
 *   vimPlugins pname, served from nixpkgs
 * - pinned-plugins.json: plugins nixpkgs does not package, pinned as
 *   fetchFromGitHub sources at the lazy-lock.json commit (or the previously
 *   pinned commit once lazy.nvim drops them from the lock file)
 *
 * Plugins listed in config.json's `exclude`, ryoppippi's own plugins and
 * virtual specs are left to lazy.nvim.
 *
 * Usage: nix run .#lazy2nix   (from the dotfiles repo root)
 */

import { mkdtempSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import * as path from 'node:path';

const L2N_DIR = import.meta.dir;
const REPO_ROOT = path.resolve(L2N_DIR, '../../../../../..');
const LOCK_PATH = path.join(REPO_ROOT, 'nvim/lazy-lock.json');

interface DumpedPlugin {
	name: string;
	url?: string;
	virtual: boolean;
	version?: string | boolean;
	branch?: string;
	commit?: string;
	has_build: boolean;
}

interface PinnedPlugin {
	owner: string;
	repo: string;
	rev: string;
	hash: string;
}

function run(cmd: string[], env?: Record<string, string>): string {
	const proc = Bun.spawnSync(cmd, {
		cwd: REPO_ROOT,
		env: { ...process.env, ...env },
		stderr: 'pipe',
	});
	if (proc.exitCode !== 0) {
		throw new Error(`${cmd.join(' ')} failed:\n${proc.stderr.toString()}`);
	}
	return proc.stdout.toString();
}

async function readJson<T>(p: string): Promise<T> {
	return (await Bun.file(p).json()) as T;
}

// 1. dump the resolved plugin table from the user's Neovim
function dumpPlugins(): DumpedPlugin[] {
	const dir = mkdtempSync(path.join(tmpdir(), 'lazy2nix-'));
	const dumpPath = path.join(dir, 'dump.json');
	try {
		run(['nvim', '--headless', `+lua dofile('${path.join(L2N_DIR, 'dump.lua')}')`, '+qa'], {
			LAZY2NIX_DUMP: dumpPath,
		});
		return JSON.parse(run(['cat', dumpPath]));
	} finally {
		rmSync(dir, { recursive: true, force: true });
	}
}

// 2. index nixpkgs vimPlugins by lowercased pname (attribute names are
//    normalised and unusable directly; tryEval skips throwing aliases)
function nixpkgsPnameIndex(): Map<string, string> {
	const expr = `vp: builtins.listToAttrs (builtins.concatMap (n: let r = builtins.tryEval (let p = vp.\${n}; in if builtins.isAttrs p && p ? pname && p ? outPath then p.pname else null); in if r.success && builtins.isString r.value then [ { name = n; value = r.value; } ] else [ ]) (builtins.attrNames vp))`;
	const json = run([
		'nix',
		'eval',
		'--json',
		'--inputs-from',
		REPO_ROOT,
		'nixpkgs#vimPlugins',
		'--apply',
		expr,
	]);
	const attrToPname = JSON.parse(json) as Record<string, string>;
	const index = new Map<string, string>();
	for (const [attr, pname] of Object.entries(attrToPname).sort()) {
		const key = pname.toLowerCase();
		if (!index.has(key)) index.set(key, attr);
		// prefer the canonical attribute (normalised repo name) over aliases
		if (attr.toLowerCase() === pname.toLowerCase().replaceAll('.', '-')) {
			index.set(key, attr);
		}
	}
	return index;
}

// 3. prefetch a GitHub rev; the flake tarball narHash equals the hash
//    fetchFromGitHub expects
function prefetchGitHub(owner: string, repo: string, rev: string): string {
	const json = run(['nix', 'flake', 'prefetch', '--json', `github:${owner}/${repo}/${rev}`]);
	return JSON.parse(json).hash as string;
}

const config = await readJson<{ exclude: string[]; overrides: Record<string, string> }>(
	path.join(L2N_DIR, 'config.json'),
);
const exclude = new Set(config.exclude);
const lock = await readJson<Record<string, { branch?: string; commit: string }>>(LOCK_PATH);
const previousPinned: Record<string, PinnedPlugin> = await Bun.file(
	path.join(L2N_DIR, 'pinned-plugins.json'),
)
	.json()
	.catch(() => ({}));

console.log('dumping lazy.nvim plugin table...');
const dumped = dumpPlugins();
console.log(`  ${dumped.length} plugins resolved`);

console.log('indexing nixpkgs vimPlugins pnames...');
const pnameIndex = nixpkgsPnameIndex();

const fromNixpkgs: Record<string, string> = {};
const pinned: Record<string, PinnedPlugin> = {};
const warnings: string[] = [];
const skipped: string[] = [];

for (const plugin of dumped) {
	const { name, url } = plugin;
	if (plugin.virtual || !url) continue;
	if (url.includes('github.com/ryoppippi/')) continue;
	if (exclude.has(name)) {
		skipped.push(name);
		continue;
	}

	const pin = [
		plugin.commit && `commit=${plugin.commit}`,
		plugin.branch && `branch=${plugin.branch}`,
		typeof plugin.version === 'string' && plugin.version !== '*' && `version=${plugin.version}`,
	].filter(Boolean);
	if (pin.length > 0) {
		warnings.push(`${name}: spec pins (${pin.join(', ')}) will NOT apply once Nix-served`);
	}
	if (plugin.has_build) {
		warnings.push(`${name}: build step will NOT run once Nix-served`);
	}

	const attr = config.overrides[name] ?? pnameIndex.get(name.toLowerCase());
	if (attr) {
		fromNixpkgs[name] = attr;
		continue;
	}

	const match = url.match(/github\.com\/([^/]+)\/(.+?)(?:\.git)?$/);
	if (!match) {
		warnings.push(`${name}: non-GitHub url ${url}, left to lazy.nvim`);
		continue;
	}
	const [, owner, repo] = match;
	const rev = lock[name]?.commit ?? previousPinned[name]?.rev;
	if (!rev) {
		warnings.push(`${name}: no commit in lazy-lock.json or previous pin, left to lazy.nvim`);
		continue;
	}
	const previous = previousPinned[name];
	const hash =
		previous && previous.rev === rev
			? previous.hash
			: (console.log(`prefetching ${owner}/${repo}@${rev.slice(0, 8)}...`),
				prefetchGitHub(owner, repo, rev));
	pinned[name] = { owner, repo, rev, hash };
}

const sortedNixpkgs = Object.fromEntries(
	Object.entries(fromNixpkgs).sort(([a], [b]) => a.localeCompare(b)),
);
const sortedPinned = Object.fromEntries(
	Object.entries(pinned).sort(([a], [b]) => a.localeCompare(b)),
);

const nixLines = [
	'# GENERATED by lazy2nix — do not edit by hand; run `nix run .#lazy2nix`.',
	'#',
	'# lazy.nvim plugin directory name -> nixpkgs vimPlugins attribute, for',
	'# every configured plugin that nixpkgs packages. Plugins to keep',
	"# git-managed belong in config.json's `exclude` list instead.",
	'{',
	...Object.entries(sortedNixpkgs).map(([name, attr]) => `  "${name}" = "${attr}";`),
	'}',
	'',
];
await Bun.write(path.join(L2N_DIR, 'nixpkgs-plugins.nix'), nixLines.join('\n'));
await Bun.write(
	path.join(L2N_DIR, 'pinned-plugins.json'),
	`${JSON.stringify(sortedPinned, null, '\t')}\n`,
);

console.log(
	`\nwrote ${Object.keys(sortedNixpkgs).length} nixpkgs plugins, ${Object.keys(sortedPinned).length} pinned plugins (${skipped.length} excluded by config)`,
);
for (const w of warnings) {
	console.warn(`warning: ${w}`);
}
