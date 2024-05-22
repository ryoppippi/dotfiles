import * as k from "karabiner_ts";

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

  k.rule("Tap CMD to toggle Kana/Eisuu").manipulators([
    k.withMapper(
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
  ])
    .condition(
      k.ifDevice([
        { product_id: 1, vendor_id: 22854 }, // Claw44
      ]).unless(),
    ),
]);
