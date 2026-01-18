# Karabiner Configuration Guide

This directory contains TypeScript-based configuration for Karabiner-Elements using `karabiner.ts`.

## Documentation

- **karabiner.ts official documentation**: https://karabiner.ts.evanliu.dev/
- **Karabiner-Elements**: https://karabiner-elements.pqrs.org/
- **Tip**: You can also use context7 MCP to check karabiner.ts documentation directly with up-to-date information

## Overview

- **Main config**: `karabiner.ts` - TypeScript configuration that generates `karabiner.json`
- **Device definitions**: `devices.ts` - Device identifier utilities
- **Utilities**: `utils.ts` - Helper functions for configuration

## Building

```bash
# Build once
deno task build

# Watch mode (auto-rebuild on changes)
deno task watch
```

## Key Concepts

### Basic Structure

```typescript
k.writeToProfile("Default profile", [
  k.rule("Rule description")
    .manipulators([
      k.map({ key_code: "key_name" })
        .to({ key_code: "target_key" })
    ]),
]);
```

### Common Patterns

#### 1. Simple Key Remapping

```typescript
k.map({ key_code: "caps_lock" })
  .to({ key_code: "escape" })
```

#### 2. Key with Modifiers

```typescript
k.map({
  key_code: "h",
  modifiers: { mandatory: ["fn"] }
})
  .to({ key_code: "left_arrow" })
```

#### 3. Tap vs Hold (Dual-Function Keys)

```typescript
k.map({ key_code: "tab" })
  .toIfAlone({ key_code: "tab" })
  .toIfHeldDown({ key_code: "tab", repeat: true })
  .to({
    key_code: "left_command",
    modifiers: ["left_option", "left_shift", "left_control"],
  })
```

#### 4. Multiple Actions with toIfAlone

```typescript
k.map({ key_code: "left_control" })
  .to({ key_code: "left_control", lazy: true })
  .toIfAlone([
    { key_code: "japanese_eisuu" },
    { key_code: "escape" },
  ])
```

#### 5. Using withMapper for Multiple Similar Mappings

```typescript
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
)
```

#### 6. Conditional Rules (Device-specific)

```typescript
k.rule("Rule name", devices.ifNotSelfMadeKeyboard)
  .manipulators([...])
```

#### 7. App-specific Rules

```typescript
k.rule(
  "Rule name",
  k.ifApp({ bundle_identifiers: ["com.app.Bundle"] })
)
  .manipulators([...])
```

#### 8. Using withCondition

```typescript
k.withCondition(
  k.ifApp("wezterm").unless()
)([
  k.map({ key_code: "comma", modifiers: { mandatory: ["control"] } })
    .to(event)
])
```

## Important Methods

### Map Methods

- `.map()` - Define key mapping
- `.to()` - Target key/action
- `.toIfAlone()` - Action when tapped (not held)
- `.toIfHeldDown()` - Action when held down
- `.description()` - Add description to the rule
- `.parameters()` - Set timing parameters

### Utility Methods

- `k.withMapper()` - Map over multiple key combinations
- `k.withCondition()` - Apply conditions to manipulators
- `k.ifApp()` - App-specific condition
- `k.toApp()` - Send to specific app

### Modifier Options

- `mandatory`: Must be pressed
- `optional`: Can be pressed with any modifier
- Common modifiers: `"command"`, `"option"`, `"shift"`, `"control"`, `"fn"`

### Parameters

- `lazy: true` - Lazy modifier evaluation
- `repeat: true/false` - Allow key repeat
- `"basic.to_if_held_down_threshold_milliseconds"` - Hold threshold timing

## Common Use Cases

### Super Key (Hyper Key)

A super key combines multiple modifiers (cmd+option+shift+ctrl):

```typescript
k.map({ key_code: "right_option" })
  .to({
    key_code: "right_command",
    modifiers: ["right_option", "right_shift", "right_control"],
  })
```

### Language Toggle on Tap

```typescript
k.map({ key_code: 'left_command', modifiers: { optional: ['any'] } })
     .to({ key_code: 'left_command', lazy: true })
 .toIfAlone({ key_code: 'japanese_eisuu' });
```

### Vim-style Arrow Keys

```typescript
k.map({
   key_code: 'h',
        modifiers: { mandatory: ['fn'] },
}).to({ key_code: 'left_arrow' });
```

## Tips

1. Always use `devices.ifNotSelfMadeKeyboard` condition for MacBook-specific mappings
2. Use `lazy: true` for modifier keys to prevent accidental triggering
3. Group related rules together for better organization
4. Use descriptive rule names for easier debugging
5. Test changes incrementally - build after each rule addition
6. Check `karabiner.json` if something doesn't work as expected

## Debugging

- Generated JSON is in `karabiner.json` - check this if rules aren't working
- Karabiner-Elements logs available in the app
- Use descriptive `.description()` to identify rules in Karabiner-Elements UI
