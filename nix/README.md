# Nix Configuration

Command reference lives in the [root README](../README.md#daily-usage).

## Structure

- **Entry point**: `flake.nix` (in repo root) — inputs only
- **Flake outputs**: `flake/` — flake-parts modules
  - `apps/` - `nix run .#<app>` entry points
  - `hosts/` - `darwinConfigurations` and `homeConfigurations`
  - `formatter.nix` - treefmt, git hooks, devShell
  - `pkgs.nix` - overrides the `pkgs` module argument with `../mk-pkgs.nix`
- **Package set**: `mk-pkgs.nix` — overlaid nixpkgs, used by `perSystem` and the hosts
- **Modules**: `modules/`
  - `home/` - Cross-platform (home-manager)
  - `darwin/` - macOS-specific (nix-darwin)
  - `linux/` - Linux-specific
  - `lib/` - Shared helpers
- **Overlays**: `overlays/`

## Common Tasks

| Task                  | Location                      |
| --------------------- | ----------------------------- |
| Add/remove packages   | `modules/home/packages.nix`   |
| macOS packages        | `modules/darwin/packages.nix` |
| Homebrew packages     | `modules/darwin/system.nix`   |
| Dotfile symlinks      | `modules/home/dotfiles.nix`   |
| macOS system settings | `modules/darwin/system.nix`   |
| Program configs       | `modules/home/programs/`      |

## Conventions

- Prefer Nix packages over Homebrew when available
- Dotfiles use `mkOutOfStoreSymlink` for mutability
