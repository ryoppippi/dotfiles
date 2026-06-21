#!/usr/bin/env nix
/*
#! nix shell --inputs-from . nixpkgs#bun -c bun
*/

// Ensure the TypeWhisper dictionary contains the custom terms and corrections
// defined in dictionary.json, via its local HTTP API.
//
// This is intentionally ADDITIVE, not a mirror. Activating a term pack
// materialises its terms and corrections into the same dictionary store this API
// exposes, and the API gives no way to tell pack-provided entries apart from
// user-defined ones. A wholesale replace would therefore wipe every activated
// term pack, so we only ever merge our own entries in and never delete. To
// remove an entry, delete it in the app (or with an explicit DELETE request).
//
// The TypeWhisper HTTP API must be enabled in Settings > Advanced. It binds to
// 127.0.0.1 only. Override the port with $TYPEWHISPER_PORT and the bearer token
// with $TYPEWHISPER_API_TOKEN when the defaults do not match.
//
// Usage:
//   ./dict-sync.ts             # sync from dictionary.json beside this script
//   ./dict-sync.ts other.json  # sync from a specific file
//   ./dict-sync.ts --strict    # exit non-zero when the API is unreachable

interface Correction {
	original: string;
	replacement: string;
	caseSensitive: boolean;
}

interface Dictionary {
	terms: string[];
	corrections: Correction[];
}

/** Narrow an unknown value parsed from JSON to a {@link Correction}. */
function isCorrection(value: unknown): value is Correction {
	if (typeof value !== 'object' || value === null) {
		return false;
	}
	const record: Record<string, unknown> = value;
	return (
		typeof record.original === 'string' &&
		typeof record.replacement === 'string' &&
		typeof record.caseSensitive === 'boolean'
	);
}

/**
 * Validate that JSON parsed from disk has the shape of a {@link Dictionary},
 * throwing a descriptive error rather than trusting an unchecked cast.
 *
 * @param data - The value returned by `JSON.parse`.
 * @param source - The file path, used only for error messages.
 * @returns The validated dictionary.
 */
function parseDictionary(data: unknown, source: string): Dictionary {
	if (typeof data !== 'object' || data === null) {
		throw new Error(`${source}: expected a JSON object`);
	}
	const record: Record<string, unknown> = data;
	const { terms, corrections } = record;
	if (!Array.isArray(terms) || !terms.every((term) => typeof term === 'string')) {
		throw new Error(`${source}: "terms" must be an array of strings`);
	}
	if (!Array.isArray(corrections) || !corrections.every(isCorrection)) {
		throw new Error(
			`${source}: "corrections" must be an array of {original, replacement, caseSensitive}`,
		);
	}
	return { terms, corrections };
}

async function main(): Promise<void> {
	const args = Bun.argv.slice(2);
	const strict = args.includes('--strict');
	// The first non-flag argument is an explicit dictionary path; otherwise use
	// the dictionary.json tracked alongside this script.
	const fileArg = args.find((arg) => !arg.startsWith('--'));
	const file = fileArg ?? `${import.meta.dir}/dictionary.json`;

	const port = Bun.env.TYPEWHISPER_PORT ?? '8978';
	const root = `http://localhost:${port}`;
	const base = `${root}/v1/dictionary`;

	// Attach a bearer token only when one is configured.
	const headers: Record<string, string> = { 'Content-Type': 'application/json' };
	if (Bun.env.TYPEWHISPER_API_TOKEN) {
		headers.Authorization = `Bearer ${Bun.env.TYPEWHISPER_API_TOKEN}`;
	}

	const dict = parseDictionary(await Bun.file(file).json(), file);

	// The API only answers when TypeWhisper is running with the HTTP API enabled.
	// That makes it an optional dependency: by default we skip quietly (exit 0)
	// so this can run from login/activation hooks without failing. --strict turns
	// an unreachable API into a hard error instead.
	const reachable = await fetch(`${root}/v1/status`, { headers })
		.then((response) => response.ok)
		.catch(() => false);

	if (!reachable) {
		const message = `typewhisper-dict-sync: API not reachable on :${port} — enable it in Settings > Advanced`;
		if (strict) {
			throw new Error(message);
		}
		console.error(`${message} (skipping)`);
		return;
	}

	// terms: merge our terms in. replace:false keeps term-pack terms intact.
	await fetch(`${base}/terms`, {
		method: 'PUT',
		headers,
		body: JSON.stringify({ terms: dict.terms, replace: false }),
	});

	// corrections: add or update each one (PUT is idempotent per original).
	for (const correction of dict.corrections) {
		await fetch(`${base}/corrections`, {
			method: 'PUT',
			headers,
			body: JSON.stringify(correction),
		});
	}

	console.log(
		`typewhisper-dict-sync: synced ${dict.terms.length} terms, ${dict.corrections.length} corrections from ${file}`,
	);
}

await main();
