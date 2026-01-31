# Kanata Configuration Guide

Cross-platform software keyboard remapper for Linux, macOS and Windows.

## Documentation

- **Kanata GitHub**: https://github.com/jtroo/kanata
- **Configuration Guide**: https://github.com/jtroo/kanata/blob/main/docs/config.adoc
- **Full Config Reference**: https://jtroo.github.io/config.html
- **macOS Setup**: https://github.com/jtroo/kanata/blob/main/docs/setup-macos.md
- **kanata-vk-agent** (app-specific rules): https://github.com/devsunb/kanata-vk-agent

## Files

| File | Description |
|------|-------------|
| `kanata.kbd` | Main Kanata configuration |

## Current Rules

1. **Ctrl tap** → eisuu + ESC, hold → Ctrl
2. **ESC** → eisuu + ESC
3. **Cmd+Q hold** to quit (tap sends q)
4. **Discord/ChatGPT**: Enter sends Enter, others send Shift+Enter
5. **Cmd tap** → Kana/Eisuu toggle
6. **Tab hold** → Hyper key (cmd+opt+shift+ctrl)
7. **Fn+hjkl** → Arrow keys
8. **Right Option** → Super key

## Device Exclusion

CLAW44 keyboard is excluded via `macos-dev-names-exclude`.

## Service Management

### macOS

Services are managed via nix-darwin launchd:
- `com.github.jtroo.kanata` - Main kanata daemon (root)
- `com.devsunb.kanata-vk-agent` - App-specific virtual key agent (user)

```bash
# Check service status
sudo launchctl list | grep kanata

# Restart Kanata daemon
sudo launchctl kickstart -k system/com.github.jtroo.kanata

# View logs
tail -f /var/log/kanata.out.log
tail -f /var/log/kanata.err.log
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
kanata --check --cfg ~/ghq/github.com/ryoppippi/dotfiles/kanata/kanata.kbd
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
- Sets up launchd daemons for kanata and kanata-vk-agent

## Virtual Keys (App-Specific Rules)

kanata-vk-agent monitors the frontmost app and presses/releases virtual keys via TCP.

### How It Works

1. Define virtual keys with bundle IDs in `kanata.kbd`:
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
       ((input virtual com.hnc.Discord)) ret break
       ((input virtual com.openai.chat)) ret break
       () S-ret break
     )
   )
   ```

3. kanata-vk-agent is configured in launchd with `-b` flag listing bundle IDs

### Finding Bundle IDs

```bash
# Run in find-id mode to discover bundle IDs
kanata-vk-agent -f
```

## Key Concepts

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
