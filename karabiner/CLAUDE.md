# Karabiner Configuration Guide

This directory contains TypeScript-based configuration for Karabiner-Elements using `karabiner.ts`.

## Documentation

- **karabiner.ts official documentation**: https://karabiner.ts.evanliu.dev/
- **Karabiner-Elements**: https://karabiner-elements.pqrs.org/
- **Tip**: You can also use context7 MCP to check karabiner.ts documentation directly with up-to-date information

## Overview

- **Main config**: `karabiner.ts` - TypeScript configuration that generates `karabiner.json`
- **Device definitions**: `devices.ts` - Device identifiers (fixed constants; the Nix sandbox cannot query HID devices)
- **Utilities**: `utils.ts` - Helper functions for configuration
- **Base template**: `karabiner.base.json` - Everything Karabiner owns outside the generated rules (profile, devices, simple modifications, fn keys). `writeToProfile` merges the rules into a copy of this file.
- **Nix module**: `nix/modules/darwin/programs/karabiner/default.nix` - Builds `karabiner.json` with bun2nix and links it to `~/.config/karabiner/karabiner.json`

## Building

`karabiner.json` is generated inside a Nix derivation and is not committed. Apply changes with:

```bash
nix run .#switch
```

The script reads two environment variables, both set by the Nix build:

- `OMNIWMCTL` - path to `omniwmctl`, embedded into the `shell_command` rules. Falls back to a PATH lookup for local runs.
- `KARABINER_JSON` - the file to read the profile from and write the result to. Falls back to `~/.config/karabiner/karabiner.json`, which is a read-only store link after switch, so use the dry run locally.

```bash
# Print the generated profile to stdout without writing anything
bun run check

# Same, re-running on every change
bun run watch
```

## Dependencies

npm dependencies are pinned twice: `bun.lock` for Bun and `bun.nix` for Nix. `package.json` runs `bun2nix -o bun.nix` as a `postinstall` script, so any `bun install`/`bun update` keeps the two in sync. `bun2nix` is installed by the Nix module; if it is missing, run `nix run github:nix-community/bun2nix -- -o bun.nix` once.

Editing `package.json` without regenerating `bun.nix` fails the Nix build.

## Key Concepts

### Basic Structure

```typescript
k.writeToProfile('Default profile', [
	k
		.rule('Rule description')
		.manipulators([k.map({ key_code: 'key_name' }).to({ key_code: 'target_key' })]),
]);
```

### Common Patterns

#### 1. Simple Key Remapping

```typescript
k.map({ key_code: 'caps_lock' }).to({ key_code: 'escape' });
```

#### 2. Key with Modifiers

```typescript
k.map({
	key_code: 'h',
	modifiers: { mandatory: ['fn'] },
}).to({ key_code: 'left_arrow' });
```

#### 3. Tap vs Hold (Dual-Function Keys)

```typescript
k.map({ key_code: 'tab' })
	.toIfAlone({ key_code: 'tab' })
	.toIfHeldDown({ key_code: 'tab', repeat: true })
	.to({
		key_code: 'left_command',
		modifiers: ['left_option', 'left_shift', 'left_control'],
	});
```

#### 4. Multiple Actions with toIfAlone

```typescript
k.map({ key_code: 'left_control' })
	.to({ key_code: 'left_control', lazy: true })
	.toIfAlone([{ key_code: 'japanese_eisuu' }, { key_code: 'escape' }]);
```

#### 5. Using withMapper for Multiple Similar Mappings

```typescript
k.withMapper<k.LetterKeyCode, k.ArrowKeyCode>({
	h: 'left_arrow',
	j: 'down_arrow',
	k: 'up_arrow',
	l: 'right_arrow',
} as const)((key, arrow) =>
	k
		.map({
			key_code: key,
			modifiers: { mandatory: ['fn'] },
		})
		.to({ key_code: arrow }),
);
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
k.map({ key_code: 'right_option' }).to({
	key_code: 'right_command',
	modifiers: ['right_option', 'right_shift', 'right_control'],
});
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
5. Test changes incrementally - run `bun run check` after each rule addition
6. Check `~/.config/karabiner/karabiner.json` if something doesn't work as expected

## Debugging

- Generated JSON is at `~/.config/karabiner/karabiner.json` (a link into the Nix store) - check this if rules aren't working
- Karabiner-Elements logs available in the app
- Use descriptive `.description()` to identify rules in Karabiner-Elements UI
