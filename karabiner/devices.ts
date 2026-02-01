import * as k from 'karabiner.ts';
import { getDeviceId } from './utils.ts';

export const CLAW44 =
	(await getDeviceId('claw44')) ??
	({ product_id: 1, vendor_id: 22854 } as const satisfies k.DeviceIdentifier);

/** not apple keyboard */
export const ifNotSelfMadeKeyboard = k.ifDevice([CLAW44]).unless();
