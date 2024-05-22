import * as k from "karabiner_ts";
import { writeToProfile } from "karabiner_ts";

writeToProfile("Default profile", [
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
    k.map({ key_code: "left_command", modifiers: { optional: ["any"] } })
      .to({ key_code: "left_command", lazy: true })
      .toIfAlone({ key_code: "japanese_eisuu" })
      .description("Tap left_command alone to switch to japanese_eisuu"),

    k.map({ key_code: "right_command", modifiers: { optional: ["any"] } })
      .to({ key_code: "right_command", lazy: true })
      .toIfAlone({ key_code: "japanese_kana" })
      .description("Tap right_command alone to switch to japanese_kana"),
  ].map((km) =>
    km.parameters({ "basic.to_if_held_down_threshold_milliseconds": 100 })
  ))
    .condition(
      k.ifDevice([
        { product_id: 1, vendor_id: 22854 }, // Claw44
      ]).unless(),
    ),
]);
