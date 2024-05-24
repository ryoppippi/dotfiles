import * as k from "karabiner_ts";

/** Hide the application by name */
function toHideApp(name: string) {
  return k.to$(
    `osascript -e 'tell application "System Events" to set visible of process "${name}" to false'`,
  );
}

/** not apple keyboard */
const ifNotSelfMadeKeyboard = k.ifDevice([
  { product_id: 1, vendor_id: 22854 }, // Claw44
]).unless();

const ifTrackpadTouched = k.ifVar("multitouch_extension_finger_count_total", 0)
  .unless();

k.writeToProfile("Default profile", [
  k.rule("Tap Ctrl -> japanese_eisuu + ESC")
    .manipulators([
      k.map({ key_code: "left_control", modifiers: { optional: ["any"] } })
        .to({ key_code: "left_control", lazy: true })
        .toIfAlone({ key_code: "japanese_eisuu", modifiers: ["left_control"] }),
    ]),

  k.rule("Tap ESC -> japanese_eisuu + esc").manipulators([
    k.map({ key_code: "escape" })
      .to([
        { key_code: "japanese_eisuu" },
        { key_code: "escape" },
      ]),
  ]),

  k.rule("Quit application by holding command-q").manipulators([
    k.map({
      key_code: "q",
      modifiers: { mandatory: ["command"], optional: ["caps_lock"] },
    })
      .toIfHeldDown({
        key_code: "q",
        modifiers: ["left_command"],
        repeat: false,
      }),
  ]),

  k.rule("Tap CMD to toggle Kana/Eisuu", ifNotSelfMadeKeyboard).manipulators([
    k.withMapper<k.ModifierKeyCode, k.JapaneseKeyCode>(
      {
        "left_command": "japanese_eisuu",
        "right_command": "japanese_kana",
      } as const,
    )((cmd, lang) =>
      k.map({ key_code: cmd, modifiers: { optional: ["any"] } })
        .to({ key_code: cmd, lazy: true })
        .toIfAlone({ key_code: lang })
        .description(`Tap ${cmd} alone to switch to ${lang}`)
        .parameters({ "basic.to_if_held_down_threshold_milliseconds": 100 })
    ),
  ]),

  k.rule("Toggle WezTerm by ctrl+,")
    .manipulators([
      k.withMapper(
        [
          toHideApp("WezTerm"),
          k.toApp("WezTerm"),
        ] as const,
      )((event, i) =>
        k.withCondition(
          ...[k.ifApp("wezterm")].map((c) => i === 0 ? c : c.unless()),
        )([
          k.map({ key_code: "comma", modifiers: { mandatory: ["control"] } })
            .to(event),
        ])
      ),
    ]),

  k.rule(
    "Swap Enter & Shift+Enter in Discord",
    k.ifApp({ bundle_identifiers: ["com.hnc.Discord"] }),
  )
    .manipulators([
      k.map({
        key_code: "return_or_enter",
        modifiers: { mandatory: ["shift"] },
      })
        .to({ key_code: "return_or_enter" }),

      k.map({ key_code: "return_or_enter" })
        .to({ key_code: "return_or_enter", modifiers: ["shift"] }),
    ]),

  k.rule(
    "toggle h/j/k/l to arrow keys",
    ifTrackpadTouched,
    ifNotSelfMadeKeyboard,
  ).manipulators([
    k.withMapper<k.LetterKeyCode, k.ArrowKeyCode>(
      {
        "h": "left_arrow",
        "j": "down_arrow",
        "k": "up_arrow",
        "l": "right_arrow",
      } as const,
    )((key, arrow) =>
      k.map({ key_code: key })
        .to({ key_code: arrow })
        .description(`Tap ${key} to ${arrow}`)
    ),
  ]),
]);
