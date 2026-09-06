import * as k from 'karabiner.ts';

/**
 * Hide an application window via System Events.
 *
 * @param name the application's process name as shown in Activity Monitor
 * @returns a shell-command event usable as a `to` target
 */
export function toHideApp(name: string) {
	return k.to$(
		`osascript -e 'tell application "System Events" to set visible of process "${name}" to false'`,
	);
}

export const ifTrackpadTouched = k.ifVar('multitouch_extension_finger_count_total', 0).unless();
