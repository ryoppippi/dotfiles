import * as k from 'karabiner.ts';
import * as devices from './devices.ts';
import * as utils from './utils.ts';

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
