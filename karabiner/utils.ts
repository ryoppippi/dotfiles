import * as k from "karabiner_ts";

/** Hide the application by name */
export function toHideApp(name: string) {
  return k.to$(
    `osascript -e 'tell application "System Events" to set visible of process "${name}" to false'`,
  );
}
