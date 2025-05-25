# Complete Nix Home Manager Migration

This document describes the migration from aqua, Homebrew, devbox, and rhysd/dotfiles to Nix Home Manager for managing packages and dotfiles.

## Migration Status

✅ All 138 packages from `aqua/aqua.yaml` migrated
✅ Homebrew packages migrated 
✅ devbox packages migrated
✅ Neovim LSP node packages included
✅ Dotfile management (replaces rhysd/dotfiles)
✅ Multi-platform support (macOS & Linux)

## Usage

### Initial Setup

1. Install Nix (if not already installed):
```bash
sh <(curl -L https://nixos.org/nix/install)
```

2. Enable flakes (add to `~/.config/nix/nix.conf`):
```
experimental-features = nix-command flakes
```

3. Apply the Home Manager configuration:
```bash
# For macOS (Apple Silicon)
nix run home-manager/master -- switch --flake .#ryoppippi@aarch64-darwin

# For macOS (Intel)
nix run home-manager/master -- switch --flake .#ryoppippi@x86_64-darwin

# For Linux
nix run home-manager/master -- switch --flake .#ryoppippi@x86_64-linux
```

### Dotfile Management

Home Manager now manages all your dotfiles via symlinks (replacing rhysd/dotfiles):
- Fish shell configuration
- Git configuration  
- Karabiner settings
- Neovim configuration
- Terminal emulator configs (Wezterm, Ghostty)
- And more...

The `home.file` section in `home.nix` creates symlinks from your repo to the appropriate config locations.

### Updating Packages

To update all packages to their latest versions:
```bash
nix flake update
home-manager switch --flake .
```

### Adding New Packages

1. Search for packages:
```bash
nix search nixpkgs <package-name>
```

2. Add to `home.packages` in `home.nix`

3. Apply changes:
```bash
home-manager switch --flake .
```

## Package Mapping Notes

Most packages have direct equivalents in nixpkgs. Some notable mappings:
- `golang/go` → `go`
- `golang/tools/*` → `go-tools` or `gotools`
- `cli/cli` → `gh`
- `stedolan/jq` → `jq`
- `mikefarah/yq` → `yq-go`
- `dduan/tre` → `tre-command`

Some packages might not be available in nixpkgs and may need to be installed via other means or contributed to nixpkgs.

## Benefits of Migration

1. **Declarative Configuration**: All tools defined in one place
2. **Atomic Updates**: Updates either succeed completely or roll back
3. **Reproducibility**: Same versions across all machines
4. **Integration**: Better integration with Nix ecosystem
5. **Rollbacks**: Easy to revert to previous configurations

## Transition Period

During the transition, you can run the old tools alongside Nix. Once comfortable with Nix:

1. **Remove aqua**:
   ```bash
   rm -rf ~/.local/share/aquaproj-aqua
   # Remove aqua from PATH in your shell config
   ```

2. **Remove devbox**:
   ```bash
   rm -rf ~/.local/share/devbox
   ```

3. **Remove rhysd/dotfiles**:
   ```bash
   # No longer needed - Nix manages symlinks now
   ```

4. **Clean up Homebrew** (optional, keep for GUI apps):
   ```bash
   # Remove CLI tools now managed by Nix
   brew uninstall <package-name>
   # Or use nix-darwin to manage Homebrew
   ```

## Benefits Over Previous Setup

- **Single source of truth**: All packages and configs in one place
- **Atomic updates**: Changes succeed or rollback completely  
- **Cross-platform**: Same config works on macOS and Linux
- **Version pinning**: Exact versions across all machines
- **No more manual symlinks**: Home Manager handles all dotfile linking