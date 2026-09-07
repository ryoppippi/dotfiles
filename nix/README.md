# Nix Configuration

Command reference lives in the [root README](../README.md#daily-usage).

## Structure

- **Entry point**: `flake.nix` (in repo root) — inputs only
- **Flake outputs**: `flake/` — flake-parts modules
  - `apps/` - `nix run .#<app>` entry points
  - `hosts/` - `darwinConfigurations` and `homeConfigurations`
  - `formatter.nix` - treefmt, git hooks, devShell
  - `pkgs.nix` - overrides the `pkgs` module argument with `../mk-pkgs.nix`
  - `writers.nix` - provides the `writeNu` module argument
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
- `nix run .#<app>` entry points are Nushell, written with the `writeNu` module
  argument rather than `pkgs.writeShellScript`. It runs `nu-check` at build time,
  so a syntax error fails the build instead of the app. Scripts that take
  arguments need `def --wrapped main [...rest]` — a plain `...rest` swallows
  unknown flags as flags to `main`
