import * as k from "karabiner_ts";
import { getDeviceId } from "./utils.ts";

export const CLAW44 = await getDeviceId("claw44");

/** not apple keyboard */
export const ifNotSelfMadeKeyboard = k.ifDevice([CLAW44]).unless();
