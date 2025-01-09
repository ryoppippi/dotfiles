import * as k from "karabiner_ts";
import * as devices from "./devices.ts";
import * as utils from "./utils.ts";

const IDENTIFIERS = {
  discord: await utils.extractIdentifer("Discord"),
  chatgpt: await utils.extractIdentifer("ChatGPT"),
} as const;

k.writeToProfile("Default profile", [
  k.rule("Tap Ctrl -> japanese_eisuu + ESC")
    .manipulators([
      k.map({ key_code: "left_control", modifiers: { optional: ["any"] } })
        .to({ key_code: "left_control", lazy: true })
        .toIfAlone([
          { key_code: "japanese_eisuu" },
          { key_code: "escape" },
        ]),
    ]),

  k.rule("Tap ESC -> japanese_eisuu + esc")
    .manipulators([
      k.map({ key_code: "escape" })
        .to([
          { key_code: "japanese_eisuu" },
          { key_code: "escape" },
        ]),
    ]),

  k.rule("Quit application by holding command-q")
    .manipulators([
      k.map({
        key_code: "q",
        modifiers: { mandatory: ["command"], optional: ["caps_lock"] },
      })
        .toIfHeldDown({
          key_code: "q",
          modifiers: ["command"],
          repeat: false,
        }),
    ]),

  k.rule("Toggle WezTerm by ctrl+,")
    .manipulators([
      k.withMapper(
        [
          utils.toHideApp("WezTerm"),
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
    "Swap Enter & Shift+Enter and CMD+Enter -> Enter on Discord and ChatGPT",
    k.ifApp({ bundle_identifiers: [IDENTIFIERS.discord, IDENTIFIERS.chatgpt] }),
  )
    .manipulators([
      k.map({
        key_code: "return_or_enter",
        modifiers: { mandatory: ["shift"] },
      })
        .to({ key_code: "return_or_enter" }),

      k.map({
        key_code: "return_or_enter",
        modifiers: { mandatory: ["command"] },
      })
        .to({ key_code: "return_or_enter" }),

      k.map({ key_code: "return_or_enter" })
        .to({ key_code: "return_or_enter", modifiers: ["shift"] }),
    ]),

  k.rule(
    "Tap Option to toggle Kana/Eisuu",
    devices.ifNotSelfMadeKeyboard,
  )
    .manipulators([
      k.withMapper<k.ModifierKeyCode, k.JapaneseKeyCode>(
        {
          "left_option": "japanese_eisuu",
          "right_option": "japanese_kana",
        } as const,
      )((cmd, lang) =>
        k.map({ key_code: cmd, modifiers: { optional: ["any"] } })
          .to({ key_code: cmd, lazy: true })
          .toIfAlone({ key_code: lang })
          .description(`Tap ${cmd} alone to switch to ${lang}`)
          .parameters({ "basic.to_if_held_down_threshold_milliseconds": 100 })
      ),
    ]),

  k.rule(
    "Hold tab to super key, tap tab to tab in Macbook",
    devices.ifNotSelfMadeKeyboard,
  ).manipulators([
    k.map({ key_code: "tab" })
      .toIfAlone({ key_code: "tab", lazy: true })
      .to({
        key_code: "left_command",
        modifiers: ["left_option", "left_shift", "left_control"],
      })
      .toIfHeldDown({
        key_code: "tab",
        repeat: true,
      }),
  ]),

  k.rule(
    "toggle fn + h/j/k/l to arrow keys",
    devices.ifNotSelfMadeKeyboard,
  ).manipulators([
    k.withMapper<k.LetterKeyCode, k.ArrowKeyCode>(
      {
        "h": "left_arrow",
        "j": "down_arrow",
        "k": "up_arrow",
        "l": "right_arrow",
      } as const,
    )((key, arrow) =>
      k.map({
        key_code: key,
        modifiers: { mandatory: ["fn"] },
      })
        .to({ key_code: arrow })
        .description(`Tap ${key} to ${arrow}`)
    ),
  ]),
]);
