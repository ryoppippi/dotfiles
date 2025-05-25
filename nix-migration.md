# Aqua to Nix Home Manager Migration

This document describes the migration from aqua to Nix Home Manager for managing CLI tools.

## Migration Status

All 138 packages from `aqua/aqua.yaml` have been migrated to `home.nix`. The packages are organized by category for better maintainability.

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
nix run home-manager/master -- switch --flake .
```

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

During the transition, you can run both aqua and Nix side by side. Once comfortable with Nix:
1. Remove aqua from PATH
2. Uninstall aqua-managed tools
3. Remove `aqua/` directory