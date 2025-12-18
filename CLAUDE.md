# Dotfiles Repository

ryoppippi's personal dotfiles managed via **Nix Flake** (nix-darwin + home-manager).

## Quick Reference

See @README.md for full documentation.

## Core Commands

```bash
git add . && nix run .#switch  # Apply changes
nix run .#update               # Update dependencies
nix run .#build                # Test build
```

## Project Structure

```
.
├── flake.nix           # Nix entry point
├── nix/modules/        # Nix configuration modules
│   ├── home/           # Cross-platform (home-manager)
│   ├── darwin/         # macOS (nix-darwin)
│   └── linux/          # Linux
├── fish/               # Fish shell config
├── nvim/               # Neovim config
├── karabiner/          # Karabiner-Elements (TypeScript)
├── wezterm/            # Wezterm terminal
├── claude/             # Claude Code config (user memory)
└── .claude/rules/      # Path-specific rules
```

## Dotfiles Locations

| Config | Location | Notes |
|--------|----------|-------|
| Fish | `fish/` | Modular config in `fish/config/` |
| Neovim | `nvim/` | Lua-based, uses Lazy.nvim |
| Karabiner | `karabiner/` | TypeScript source, see `karabiner/CLAUDE.md` |
| Wezterm | `wezterm/` | Lua config |
| Git | `nix/modules/home/programs/git/` | Declarative via Home Manager |
| Ghostty | `nix/modules/home/programs/ghostty.nix` | Declarative |

## Git Workflow

- **Main branch**: `main`
- **Never push to main directly** - create a PR
- Use **Conventional Commits** with UK English spelling
- Commits are GPG-signed with SSH

## System Info

- **Platform**: aarch64-darwin (Apple Silicon)
- **Shell**: Fish
- **Editor**: Neovim
