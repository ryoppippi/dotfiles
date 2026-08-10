import * as k from 'karabiner.ts';
import * as devices from './devices.ts';
import * as utils from './utils.ts';

const omniwmctl = Bun.which('omniwmctl');
if (omniwmctl == null) {
	throw new Error('omniwmctl not found on PATH; is the omniwm module active?');
}

k.writeToProfile('Default profile', [
	k
		.rule('Block control tap while Tab window modifier is held', devices.ifNotSelfMadeKeyboard)
		.manipulators([
			k
				.map({
					key_code: 'caps_lock',
					modifiers: { mandatory: ['command', 'option', 'shift'], optional: ['any'] },
				})
				.toNone(),
			k
				.map({
					key_code: 'left_control',
					modifiers: { mandatory: ['command', 'option', 'shift'], optional: ['any'] },
				})
				.toNone(),
		]),

	k.rule('Tap Ctrl -> japanese_eisuu + ESC', devices.ifNotSelfMadeKeyboard).manipulators([
		k
			.map({ key_code: 'left_control', modifiers: { optional: ['any'] } })
			.to({ key_code: 'left_control', lazy: true })
			.toIfAlone([{ key_code: 'japanese_eisuu' }, { key_code: 'escape' }]),
	]),

	k
		.rule('Tap ESC -> japanese_eisuu + esc', devices.ifNotSelfMadeKeyboard)
		.manipulators([
			k.map({ key_code: 'escape' }).to([{ key_code: 'japanese_eisuu' }, { key_code: 'escape' }]),
		]),

	k.rule('Quit application by holding command-q').manipulators([
		k
			.map({
				key_code: 'q',
				modifiers: { mandatory: ['command'], optional: ['caps_lock'] },
			})
			.toIfHeldDown({
				key_code: 'q',
				modifiers: ['command'],
				repeat: false,
			}),
	]),

	k.rule('Open cmux directly with control-comma').manipulators([
		k
			.map({
				key_code: 'comma',
				modifiers: { mandatory: ['control'], optional: ['caps_lock'] },
			})
			.to$('/usr/bin/open -b com.cmuxterm.app'),
	]),

	k.rule('Tap CMD to toggle Kana/Eisuu', devices.ifNotSelfMadeKeyboard).manipulators([
		k.withMapper<k.ModifierKeyCode, k.JapaneseKeyCode>({
			left_command: 'japanese_eisuu',
			right_command: 'japanese_kana',
		} as const)((cmd, lang) =>
			k
				.map({ key_code: cmd, modifiers: { optional: ['any'] } })
				.to({ key_code: cmd, lazy: true })
				.toIfAlone({ key_code: lang })
				.description(`Tap ${cmd} alone to switch to ${lang}`)
				.parameters({ 'basic.to_if_held_down_threshold_milliseconds': 100 }),
		),
	]),

	k
		.rule('Hold tab to window modifier, tap tab to tab in MacBook', devices.ifNotSelfMadeKeyboard)
		.manipulators([
			k
				.map({ key_code: 'tab' })
				.toIfAlone({ key_code: 'tab', lazy: true })
				.toIfHeldDown({ key_code: 'tab', repeat: true })
				.to({
					key_code: 'left_command',
					modifiers: ['left_option', 'left_shift'],
				}),
		]),

	// OmniWM binds one shortcut per command, and `Workspace+Tab` (switch to the
	// last active workspace) is unreachable on the MacBook because holding Tab is
	// what produces the Workspace layer in the first place. Aliasing Return onto
	// Tab within that layer adds a second way in without taking the first away,
	// so the CLAW44 keeps the Tab it can press comfortably and both keyboards
	// accept either key. Deliberately not restricted to one device: rewriting a
	// modifier+key combination collides with nothing in the CLAW44 firmware.
	k.rule('Workspace+Return also switches workspace back and forth').manipulators([
		k
			.map({
				key_code: 'return_or_enter',
				modifiers: { mandatory: ['command', 'option', 'shift'] },
			})
			.to({ key_code: 'tab', modifiers: ['left_command', 'left_option', 'left_shift'] }),
	]),

	// Ctrl+Shift carries the focused window along. Vertical crosses displays,
	// horizontal stays within one display's workspaces. Not restricted to one
	// device: any keyboard that can send Ctrl/Ctrl+Shift plus an arrow key gets
	// the same behaviour.
	k.rule('Ctrl+Up/Down focuses the other display').manipulators(
		(
			[
				['up_arrow', 'next'],
				['down_arrow', 'prev'],
			] as const
		).map(([arrow, target]) =>
			k
				.map({ key_code: arrow, modifiers: { mandatory: ['left_control'] } })
				.to$(`${omniwmctl} command focus-monitor ${target}`),
		),
	),

	k.rule('Ctrl+Left/Right switches workspace').manipulators(
		(
			[
				['left_arrow', 'prev'],
				['right_arrow', 'next'],
			] as const
		).map(([arrow, target]) =>
			k
				.map({ key_code: arrow, modifiers: { mandatory: ['left_control'] } })
				.to$(`${omniwmctl} command switch-workspace ${target}`),
		),
	),

	// Absolute workspace numbers, not `move-to-workspace on-monitor <n> <up|down>`.
	// Workspaces are pinned to the main/secondary display, so naming one already
	// names a display. The directional form would additionally depend on OmniWM's
	// Custom Monitor Routing Arrangement, which lives outside this repository
	// because it is keyed by display UUID, and it needs the destination workspace
	// anyway — so the direction argument buys nothing.
	k.rule('Ctrl+Shift+Up/Down moves the focused window across displays').manipulators(
		(
			[
				['up_arrow', '1'],
				['down_arrow', '3'],
			] as const
		).map(([arrow, workspace]) =>
			k
				.map({
					key_code: arrow,
					modifiers: { mandatory: ['left_control', 'left_shift'] },
				})
				.to$(`${omniwmctl} command move-to-workspace ${workspace}`),
		),
	),

	k.rule('Ctrl+Shift+Left/Right moves the focused window within the display').manipulators(
		(['left_arrow', 'right_arrow'] as const).map((arrow) =>
			k
				.map({
					key_code: arrow,
					modifiers: { mandatory: ['left_control', 'left_shift'] },
				})
				.to({
					key_code: arrow,
					modifiers: ['left_command', 'left_option', 'left_shift'],
				}),
		),
	),

	k.rule('Map fn to super key in MacBook', devices.ifNotSelfMadeKeyboard).manipulators([
		k.map({ key_code: 'fn' }).to({
			key_code: 'left_command',
			lazy: true,
			modifiers: ['left_option', 'left_shift', 'left_control'],
		}),
	]),

	k
		.rule('Map right option to fn in MacBook', devices.ifNotSelfMadeKeyboard)
		.manipulators([k.map({ key_code: 'right_option' }).to({ key_code: 'fn', lazy: true })]),
]);
