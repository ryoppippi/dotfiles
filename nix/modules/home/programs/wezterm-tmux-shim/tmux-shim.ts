import { $ } from 'bun';
import process from 'node:process';

$.throws(false);

const REAL_TMUX = Bun.env.REAL_TMUX!;
const WEZTERM = Bun.env.WEZTERM_CLI!;
const WEZTERM_PANE = Bun.env.WEZTERM_PANE;

if (!WEZTERM_PANE) {
	const proc = Bun.spawnSync([REAL_TMUX, ...Bun.argv.slice(2)], {
		stdin: 'inherit',
		stdout: 'inherit',
		stderr: 'inherit',
	});
	process.exit(proc.exitCode);
}

// --- Utility functions ---

function stripPanePrefix(id: string): string {
	return id.startsWith('%') ? id.slice(1) : id;
}

function addPanePrefix(id: string): string {
	return `%${id}`;
}

function parseTargetPane(target: string): string {
	if (target.startsWith('%')) return stripPanePrefix(target);
	if (target.includes('.')) return stripPanePrefix(target.split('.').pop()!);
	return target;
}

interface PaneInfo {
	pane_id: number;
	tab_id: number;
	window_id: number;
	workspace: string;
	cwd: string;
}

async function getPaneList(): Promise<PaneInfo[]> {
	const result = await $`${WEZTERM} cli list --format json`.quiet();
	if (result.exitCode !== 0) return [];
	return result.json();
}

async function getTabIdForPane(paneId: string): Promise<string | undefined> {
	const panes = await getPaneList();
	const p = panes.find((p) => String(p.pane_id) === paneId);
	return p ? String(p.tab_id) : undefined;
}

// --- Command handlers ---

async function handleSplitWindow(args: string[]) {
	let targetPane = WEZTERM_PANE!;
	let direction = '--bottom';
	const sizeArgs: string[] = [];
	let printPane = false;
	const prog: string[] = [];

	for (let i = 0; i < args.length; i++) {
		switch (args[i]) {
			case '-t':
				targetPane = parseTargetPane(args[++i]);
				break;
			case '-h':
				direction = '--right';
				break;
			case '-v':
				direction = '--bottom';
				break;
			case '-l': {
				const size = args[++i];
				if (size.endsWith('%')) sizeArgs.push('--percent', size.slice(0, -1));
				else sizeArgs.push('--cells', size);
				break;
			}
			case '-P':
				printPane = true;
				break;
			case '-F':
				i++;
				break;
			case '-d':
				break;
			case '--':
				prog.push(...args.slice(i + 1));
				i = args.length;
				break;
			default:
				prog.push(args[i]);
				break;
		}
	}

	const cmd = [WEZTERM, 'cli', 'split-pane', direction, '--pane-id', targetPane, ...sizeArgs];
	if (prog.length > 0) cmd.push('--', ...prog);

	const result = await $`${cmd}`.quiet();
	const newPaneId = result.text().trim();

	if (printPane && newPaneId) console.log(addPanePrefix(newPaneId));
}

async function handleNewWindow(args: string[]) {
	let name = '';
	let printPane = false;
	const prog: string[] = [];

	for (let i = 0; i < args.length; i++) {
		switch (args[i]) {
			case '-t':
				i++;
				break;
			case '-n':
				name = args[++i];
				break;
			case '-P':
				printPane = true;
				break;
			case '-F':
				i++;
				break;
			case '-d':
				break;
			case '--':
				prog.push(...args.slice(i + 1));
				i = args.length;
				break;
			default:
				prog.push(args[i]);
				break;
		}
	}

	const cmd = [WEZTERM, 'cli', 'spawn'];
	if (prog.length > 0) cmd.push('--', ...prog);

	const result = await $`${cmd}`.quiet();
	const newPaneId = result.text().trim();

	if (name && newPaneId) {
		await $`${WEZTERM} cli set-tab-title ${name} --pane-id ${newPaneId}`.quiet();
	}

	if (printPane && newPaneId) console.log(addPanePrefix(newPaneId));
}

async function handleListPanes(args: string[]) {
	let target = '';
	let allFlag = false;

	for (let i = 0; i < args.length; i++) {
		switch (args[i]) {
			case '-t':
				target = args[++i];
				break;
			case '-F':
				i++;
				break;
			case '-a':
				allFlag = true;
				break;
		}
	}

	let tabId: string | undefined;
	if (target) {
		tabId = target.includes(':') ? await getTabIdForPane(WEZTERM_PANE!) : target;
	} else {
		tabId = await getTabIdForPane(WEZTERM_PANE!);
	}

	const panes = await getPaneList();
	for (const p of panes) {
		if (allFlag || !tabId || String(p.tab_id) === tabId) {
			console.log(`%${p.pane_id}`);
		}
	}
}

async function handleSendKeys(args: string[]) {
	let targetPane = WEZTERM_PANE!;
	const keys: string[] = [];

	for (let i = 0; i < args.length; i++) {
		switch (args[i]) {
			case '-t':
				targetPane = parseTargetPane(args[++i]);
				break;
			case '-l':
				break;
			default:
				keys.push(args[i]);
				break;
		}
	}

	let text = '';
	let appendNewline = false;

	for (let i = 0; i < keys.length; i++) {
		if (i === keys.length - 1 && (keys[i] === 'Enter' || keys[i] === 'C-m')) {
			appendNewline = true;
			continue;
		}
		if (text) text += ' ';
		text += keys[i];
	}

	if (appendNewline) text += '\n';

	if (text) {
		await $`${WEZTERM} cli send-text --pane-id ${targetPane} --no-paste -- ${text}`.quiet();
	}
}

async function handleDisplayMessage(args: string[]) {
	let targetPane = WEZTERM_PANE!;
	let format = '';

	for (let i = 0; i < args.length; i++) {
		switch (args[i]) {
			case '-p':
				break;
			case '-t':
				targetPane = parseTargetPane(args[++i]);
				break;
			case '-F':
				format = args[++i];
				break;
			default:
				if (!format) format = args[i];
				break;
		}
	}

	if (!format) return;

	let result = format;

	if (result.includes('#{pane_id}')) {
		result = result.replaceAll('#{pane_id}', `%${targetPane}`);
	}

	if (result.includes('#{window_id}')) {
		const tabId = await getTabIdForPane(targetPane);
		result = result.replaceAll('#{window_id}', `@${tabId ?? '0'}`);
	}

	if (result.includes('#{session_name}')) {
		const panes = await getPaneList();
		const p = panes.find((p) => String(p.pane_id) === targetPane);
		result = result.replaceAll('#{session_name}', p?.workspace ?? 'default');
	}

	if (result.includes('#{pane_current_path}')) {
		const panes = await getPaneList();
		const p = panes.find((p) => String(p.pane_id) === targetPane);
		result = result.replaceAll('#{pane_current_path}', p?.cwd ?? '');
	}

	if (result.includes('#{window_index}')) {
		const tabId = await getTabIdForPane(targetPane);
		result = result.replaceAll('#{window_index}', tabId ?? '0');
	}

	console.log(result);
}

async function handleCapturePane(args: string[]) {
	let targetPane = WEZTERM_PANE!;
	let printMode = false;
	let startLine = '';

	for (let i = 0; i < args.length; i++) {
		switch (args[i]) {
			case '-t':
				targetPane = parseTargetPane(args[++i]);
				break;
			case '-p':
				printMode = true;
				break;
			case '-S':
				startLine = args[++i];
				break;
		}
	}

	if (printMode) {
		const cmd = [WEZTERM, 'cli', 'get-text', '--pane-id', targetPane];
		if (startLine) cmd.push('--start-line', startLine);
		const result = await $`${cmd}`.quiet();
		process.stdout.write(result.text());
	}
}

async function handleKillPane(args: string[]) {
	let targetPane = WEZTERM_PANE!;
	for (let i = 0; i < args.length; i++) {
		if (args[i] === '-t') targetPane = parseTargetPane(args[++i]);
	}
	await $`${WEZTERM} cli kill-pane --pane-id ${targetPane}`.quiet();
}

async function handleKillSession(args: string[]) {
	let target = '';
	for (let i = 0; i < args.length; i++) {
		if (args[i] === '-t') target = args[++i];
	}

	const tabId = target
		? target.includes(':')
			? await getTabIdForPane(WEZTERM_PANE!)
			: target
		: await getTabIdForPane(WEZTERM_PANE!);

	const panes = await getPaneList();
	for (const p of panes) {
		if (String(p.tab_id) === tabId) {
			await $`${WEZTERM} cli kill-pane --pane-id ${String(p.pane_id)}`.quiet();
		}
	}
}

async function handleSelectPane(args: string[]) {
	let targetPane = WEZTERM_PANE!;
	for (let i = 0; i < args.length; i++) {
		switch (args[i]) {
			case '-t':
				targetPane = parseTargetPane(args[++i]);
				break;
			case '-T':
			case '-P':
				i++;
				break;
		}
	}
	await $`${WEZTERM} cli activate-pane --pane-id ${targetPane}`.quiet();
}

// --- Main dispatch ---

const argv = Bun.argv.slice(2);
let idx = 0;

while (idx < argv.length) {
	if (argv[idx] === '-V') {
		console.log('tmux 3.5a');
		process.exit(0);
	}
	if (['-L', '-S', '-f'].includes(argv[idx])) {
		idx += 2;
		continue;
	}
	break;
}

const subcmd = argv[idx] ?? '';
const subcmdArgs = argv.slice(idx + 1);

switch (subcmd) {
	case 'has-session':
		process.exit(0);
		break;
	case 'split-window':
		await handleSplitWindow(subcmdArgs);
		break;
	case 'new-window':
	case 'new-session':
		await handleNewWindow(subcmdArgs);
		break;
	case 'list-panes':
		await handleListPanes(subcmdArgs);
		break;
	case 'send-keys':
		await handleSendKeys(subcmdArgs);
		break;
	case 'select-layout':
	case 'kill-server':
	case 'show-options':
	case 'switch-client':
	case 'resize-pane':
		process.exit(0);
		break;
	case 'select-pane':
		await handleSelectPane(subcmdArgs);
		break;
	case 'display-message':
		await handleDisplayMessage(subcmdArgs);
		break;
	case 'capture-pane':
		await handleCapturePane(subcmdArgs);
		break;
	case 'kill-pane':
		await handleKillPane(subcmdArgs);
		break;
	case 'kill-session':
		await handleKillSession(subcmdArgs);
		break;
	case '':
		console.log('tmux 3.5a');
		break;
	default:
		console.error(`tmux-shim: unsupported command: ${subcmd}`);
		process.exit(1);
}
