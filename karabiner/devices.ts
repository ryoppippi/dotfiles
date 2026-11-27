import * as k from 'karabiner.ts';

/**
 * The self-made split keyboards. Their firmware already provides the layers,
 * home-row mods and 英数/かな that the MacBook rules emulate.
 *
 * Fixed identifiers instead of a `hidutil list` lookup: the config is built
 * inside the Nix sandbox where no HID devices are visible, and the IDs are
 * baked into the board's firmware anyway.
 */
export const CLAW44 = { product_id: 1, vendor_id: 22854 } as const satisfies k.DeviceIdentifier;
export const WINGS42 = { product_id: 5, vendor_id: 22854 } as const satisfies k.DeviceIdentifier;

/** not apple keyboard */
export const ifNotSelfMadeKeyboard = k.ifDevice([CLAW44, WINGS42]).unless();
