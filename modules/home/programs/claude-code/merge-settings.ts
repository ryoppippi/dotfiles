#!/usr/bin/env bun

// Get paths from environment variables
const baseSettingsPath = process.env.BASE_SETTINGS!;
const darwinSettingsPath = process.env.DARWIN_SETTINGS!;
const bunPath = process.env.BUN_PATH!;
const terminalNotifierPath = process.env.TERMINAL_NOTIFIER_PATH!;
const jqPath = process.env.JQ_PATH!;
const isDarwin = process.env.IS_DARWIN === '1';

// Read and parse base settings
const baseSettings = await Bun.file(baseSettingsPath).json();

// Replace placeholders in base settings
const baseWithPaths = JSON.stringify(baseSettings).replace(/__BUN_PATH__/g, bunPath);
const baseFinal = JSON.parse(baseWithPaths);

let result = baseFinal;

// On Darwin, merge with darwin settings
if (isDarwin && darwinSettingsPath) {
	const darwinSettings = await Bun.file(darwinSettingsPath).json();

	// Replace placeholders in darwin settings
	const darwinWithPaths = JSON.stringify(darwinSettings)
		.replace(/__TERMINAL_NOTIFIER_PATH__/g, terminalNotifierPath)
		.replace(/__JQ_PATH__/g, jqPath);
	const darwinFinal = JSON.parse(darwinWithPaths);

	// Merge: darwin settings override base
	result = {
		...baseFinal,
		...darwinFinal,
	};
}

// Write merged settings to stdout
console.log(JSON.stringify(result, null, 2));
