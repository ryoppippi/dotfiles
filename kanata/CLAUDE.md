# Kanata Configuration Guide

Cross-platform software keyboard remapper for Linux, macOS and Windows.

## Documentation

- **Kanata GitHub**: https://github.com/jtroo/kanata
- **Configuration Guide**: https://github.com/jtroo/kanata/blob/main/docs/config.adoc
- **Full Config Reference**: https://jtroo.github.io/config.html
- **macOS Setup**: https://github.com/jtroo/kanata/blob/main/docs/setup-macos.md
- **kanata-vk-agent** (app-specific rules): https://github.com/devsunb/kanata-vk-agent

## Files

| File          | Description                                 |
| ------------- | ------------------------------------------- |
| `common.kbd`  | Shared rules (Enter app-specific, F5→F19)   |
| `macbook.kbd` | MacBook internal keyboard (includes common) |
| `claw44.kbd`  | CLAW44 external keyboard (includes common)  |

## Configuration Structure

Two separate kanata instances run for each keyboard:

- **MacBook** (`macos-dev-names-include ("Apple Internal Keyboard / Trackpad")`)
- **CLAW44** (`macos-dev-names-include ("/ Trackpad")`) - Note: CLAW44 appears as "/ Trackpad" with vendor_id 22854

### MacBook Rules

1. **Caps Lock** → Ctrl (tap: eisuu + ESC, hold: Ctrl)
2. **Ctrl tap** → eisuu + ESC, hold → Ctrl
3. **ESC** → eisuu + ESC
4. **Cmd+Q hold** to quit (tap sends q)
5. **Cmd tap** → Kana/Eisuu toggle
6. **Tab hold** → Hyper key (cmd+opt+shift+ctrl)
7. **Fn+hjkl** → Arrow keys
8. **Right Option** → Super key
9. **F3→F17, F4→F18, F5→F19, F6→F16, F9→next**
10. **Backslash ↔ Backspace** swap
11. **Discord/ChatGPT**: Enter → Shift+Enter

### CLAW44 Rules

1. **F5→F19** (for Aqua Voice)
2. **Discord/ChatGPT**: Enter → Shift+Enter

## Service Management

### macOS

Two kanata daemons run via nix-darwin launchd:

- `com.github.jtroo.kanata.macbook` - MacBook keyboard (port 5829)
- `com.github.jtroo.kanata.claw44` - CLAW44 keyboard (port 5830)
- `com.devsunb.kanata-vk-agent` - App-specific virtual key agent

```bash
# Check service status
sudo launchctl list | grep kanata

# Restart MacBook kanata
sudo launchctl kickstart -k system/com.github.jtroo.kanata.macbook

# Restart CLAW44 kanata
sudo launchctl kickstart -k system/com.github.jtroo.kanata.claw44

# View logs
tail -f /var/log/kanata-macbook.out.log
tail -f /var/log/kanata-macbook.err.log
tail -f /var/log/kanata-claw44.out.log
tail -f /var/log/kanata-claw44.err.log
tail -f /tmp/kanata-vk-agent.out.log
```

### Linux

```bash
# Check service status
systemctl --user status kanata

# Restart Kanata
systemctl --user restart kanata

# View logs
journalctl --user -u kanata -f
```

## Validation

Always validate config before applying:

```bash
kanata --check --cfg ~/ghq/github.com/ryoppippi/dotfiles/kanata/macbook.kbd
kanata --check --cfg ~/ghq/github.com/ryoppippi/dotfiles/kanata/claw44.kbd
```

## List Available Devices

```bash
sudo kanata --list
```

## Nix Integration

### Packages (nixpkgs + overlay)

- `kanata` - from nixpkgs
- `kanata-vk-agent` - from overlay (`nix/overlays/kanata-vk-agent.nix`)
- `karabiner-driverkit` - pkg fetched and installed via activation script

### Service Configuration

See `nix/modules/darwin/services/kanata.nix`:

- Installs Karabiner-DriverKit-VirtualHIDDevice automatically
- Activates the driver on each `nix run .#switch`
- Sets up launchd daemons for both keyboards and kanata-vk-agent

## Virtual Keys (App-Specific Rules)

kanata-vk-agent monitors the frontmost app and presses/releases virtual keys via TCP.

### How It Works

1. Define virtual keys with bundle IDs in `common.kbd`:

   ```lisp
   (defvirtualkeys
     com.hnc.Discord nop0
     com.openai.chat nop0
   )
   ```

2. Use `switch` with `input virtual` to check active app:

   ```lisp
   (defalias
     enter-app (switch
       ((input virtual com.hnc.Discord)) S-ret break
       ((input virtual com.openai.chat)) S-ret break
       () ret break
     )
   )
   ```

3. kanata-vk-agent connects to both kanata instances (ports 5829,5830) with `-p` flag

### Finding Bundle IDs

```bash
# Run in find-id mode to discover bundle IDs
kanata-vk-agent -f
```

## Key Concepts

### Include

```lisp
(include common.kbd)  ;; Include shared configuration
```

### Layers

```lisp
(deflayer default ...)   ;; Base layer
(deflayer arrows ...)    ;; Fn layer for arrow keys
```

### Aliases

```lisp
(defalias
  lctl-esc (tap-hold-press 200 200 (macro eisu esc) lctl)
)
```

### Common Actions

- `tap-hold-press <tap-timeout> <hold-timeout> <tap-action> <hold-action>`
- `macro <key1> <key2> ...` - Send multiple keys in sequence
- `layer-while-held <layer-name>` - Activate layer while key is held
- `multi <mod1> <mod2> ...` - Combine multiple modifiers
- `switch` - Conditional action based on virtual keys, layers, etc.

## Migrated From

Previously configured via Karabiner-Elements with TypeScript (`karabiner.ts`).
