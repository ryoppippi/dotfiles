import * as k from 'karabiner.ts';

/**
 * CLAW44, the self-made split keyboard.
 *
 * Fixed identifiers instead of a `hidutil list` lookup: the config is built
 * inside the Nix sandbox where no HID devices are visible, and the IDs are
 * baked into the board's firmware anyway.
 */
export const CLAW44 = { product_id: 1, vendor_id: 22854 } as const satisfies k.DeviceIdentifier;

/** not apple keyboard */
export const ifNotSelfMadeKeyboard = k.ifDevice([CLAW44]).unless();
