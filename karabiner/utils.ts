import * as k from "karabiner_ts";
import * as u from "@core/unknownutil";
import { $ } from "@david/dax";

/** Hide the application by name */
export function toHideApp(name: string) {
  return k.to$(
    `osascript -e 'tell application "System Events" to set visible of process "${name}" to false'`,
  );
}

/** Get the bundle identifier of the application by name */
export async function extractIdentifer(appName: string) {
  const appPath = $.path(`/Applications/${appName}.app`);

  if (!await appPath.exists()) {
    throw new Error(`Application ${appName} not found`);
  }

  /* output is like `kMDItemCFBundleIdentifier = "com.apple.Safari"` */
  const output = await $`mdls -name kMDItemCFBundleIdentifier ${appPath}`
    .text();

  /** output is like com.apple.Safari */
  const identifer = output.match(/"(.*)"/)?.[1];

  u.assert(identifer, u.isString, {
    message: `Failed to extract bundle identifier for ${appName}`,
  });

  return identifer;
}
