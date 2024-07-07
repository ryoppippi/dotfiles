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
export async function extractIdentifer(appName: string): Promise<string> {
  const appPath = $.path(`/Applications/${appName}.app`);

  if (!await appPath.exists()) {
    throw new Error(`Application ${appName} not found`);
  }

  /* output is like `kMDItemCFBundleIdentifier = "com.apple.Safari"` */
  const output = await $`mdls -name kMDItemCFBundleIdentifier ${appPath}`
    .text();

  /** output is like com.apple.Safari */
  const identifer = output.match(/"(.*)"/)?.at(1)?.trim();

  u.assert(identifer, u.isString, {
    message: `Failed to extract bundle identifier for ${appName}`,
  });

  return identifer;
}

export async function getDeviceId(
  deviceName: string,
): Promise<Readonly<k.DeviceIdentifier>> {
  const output = await $`hidutil list -n`.lines();

  const devices = output.map((line) => JSON.parse(line));

  const _devices = new Map(devices
    .map((device) => [
      device.Product,
      {
        product_id: device.ProductID as number,
        vendor_id: device.VendorID as number,
        // location_id: device.LocationID as number,
      } as const satisfies k.DeviceIdentifier,
    ]));

  const info = _devices.get(deviceName);

  if (u.isNullish(info)) {
    throw new Error(`Device not found: ${deviceName}`);
  }
  return info;
}
