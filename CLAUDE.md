# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is ryoppippi's personal dotfiles repository managed with `dotfiles` CLI (rhysd/dotfiles). The repository includes configurations for Fish shell, Neovim, Karabiner-Elements, Wezterm, Ghostty, and various development tools. System configuration is managed via **Nix Flake** using nix-darwin and home-manager.

## Nix Configuration Management

This repository uses **Nix Flake** for declarative system configuration on macOS (Apple Silicon).

### Core Commands

```bash
# Apply Nix configuration changes
nix run .#switch

# Update all flake dependencies
nix run .#update

# Update AI tools specifically
nix run .#update-ai-tools

# Test build without applying
nix run .#build
```

### Flake Structure

- **Main config**: `flake.nix` - Defines system packages, Homebrew apps, and environment
- **Inputs**:
  - `nixpkgs` - Main package source
  - `nix-darwin` - macOS system configuration
  - `home-manager` - User environment management
  - `ai-tools` - AI development tools (codex, cursor-agent, opencode, copilot-cli, coderabbit-cli)
  - `claude-code-overlay` - Claude Code package

- **System configuration**: Lines 52-268 define nix-darwin settings including:
  - Touch ID for sudo authentication
  - Homebrew packages (taps, brews, casks, masApps)
  - Fish shell as default shell

- **Home-manager packages**: Lines 280-420 define user packages managed by Nix including:
  - VCS tools (git, gh, ghq, lazygit)
  - Search/file utilities (rg, fd, fzf, bat, eza)
  - Development languages (go, bun, deno, nodejs)
  - Language servers (lua-language-server, efm-langserver)
  - AI tools (claude-code, codex, cursor-agent, etc.)

### Modifying Packages

1. Edit `flake.nix`:
   - Add Nix packages to `home.packages` array (line 280+)
   - Add Homebrew packages to appropriate sections (lines 106-266)
2. Run `nix run .#switch` to apply changes
3. If updating flake inputs, run `nix run .#update` first

### Package Management Hierarchy

- **Nix (preferred)**: Most CLI tools and development packages
- **Homebrew**: macOS-specific apps, casks, and tools not in nixpkgs
- **Aqua**: Additional package management via `aqua/aqua.yaml`

## Shell Environment (Fish)

Primary shell is Fish. Configuration is modularised:

- **Main config**: `fish/config.fish` - Loads all sub-configs from `fish/config/*.fish`
- **Functions**: `fish/user_functions/*.fish` - Custom Fish functions
- **Theme**: `fish/themes/kanagawa.fish`

### Key Environment Variables

- Editors: `EDITOR=nvim`, `GIT_EDITOR=nvim`, `MANPAGER=nvim`
- Claude Code: `CLAUDE_CONFIG_DIR=$XDG_CONFIG_HOME/claude`
- Codex: `CODEX_HOME=$XDG_CONFIG_HOME/codex`
- XDG paths properly configured

### Path Configuration

Managed via `fish_add_path` in `fish/config.fish`. Includes Nix home-manager paths (line 79).

## Git Configuration

- **Config file**: `git/config`
- **Key aliases**:
  - `git com` - Checkout main/master branch automatically
  - `git apf` - Interactive add with fzf + delta preview
  - `git browse` - Open repo in browser (uses gh)
  - `git swf` - Switch branch with fzf
  - `git logg` - Pretty log with graph
- **Delta pager**: Configured with side-by-side diff, line numbers, syntax highlighting
- **Signing**: Commits are GPG-signed with SSH (`commit.gpgsign = true`, `gpg.format = ssh`)
- **Rebase**: Auto-stash, auto-squash, and update refs enabled
- **Default branch**: `main`

## Karabiner Configuration

Karabiner-Elements is configured using **TypeScript** via karabiner.ts library.

- **Directory**: `karabiner/`
- **Main config**: `karabiner/karabiner.ts` - TypeScript source
- **Generated output**: `karabiner/karabiner.json` - Auto-generated, do not edit directly
- **Device definitions**: `karabiner/devices.ts`
- **Utilities**: `karabiner/utils.ts`

### Build Commands

```bash
# In karabiner/ directory
deno task build   # Build once
deno task watch   # Watch mode for development
```

### Important Notes

- Always edit `karabiner.ts`, never `karabiner.json` directly
- Check `karabiner/CLAUDE.md` for detailed karabiner.ts API documentation
- Use `devices.ifNotSelfMadeKeyboard` for MacBook-specific mappings
- Test incrementally - build after each rule addition

## Neovim Configuration

- **Location**: `nvim/`
- **Entry point**: `nvim/init.lua`
- **Plugin manager**: Lazy.nvim (lockfile at `nvim/lazy-lock.json`)
- **Structure**: Lua-based configuration in `nvim/lua/`

## Terminal Emulators

Two terminal emulators are configured:

- **Wezterm**: `wezterm/wezterm.lua` (with modular configs in `wezterm/`)
- **Ghostty**: `ghostty/config`

## Development Tools

The following tools are available and preferred over their alternatives:

- **Search**: Use `rg` (ripgrep) instead of grep
- **Find**: Use `fd` instead of find
- **Cat**: Use `bat` instead of cat
- **Ls**: Use `eza` instead of ls
- **JSON**: Use `jq` for JSON processing
- **Spell check**: Use `typos` for spell checking
- **Package runners**: Use `bunx` or `bun x` instead of npx

## Installation & Setup

### Initial Setup

```bash
# Install Determinate Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# Apply nix-darwin configuration (first time)
sudo nix run nix-darwin -- switch --flake .#ryoppippi

# Reload shell
exec fish
```

### Daily Workflow

1. Edit configurations (flake.nix, fish configs, etc.)
2. Apply Nix changes: `nix run .#switch`
3. For Karabiner changes: `cd karabiner && deno task build`
4. Commit changes (never push to main directly - create PR)

## Git Workflow

- **Current branch**: `nix`
- **Main branch**: `main`
- **Branch protection**: Do not push to main directly without permission
- **Commit strategy**: Use git-commit-crafter skill for structured commits
- **Commit messages**: Must be in English with UK spelling
- **Conventional Commits**: Follow conventional commits specification

## File Locations

- **Claude config**: `claude/` (also `~/.config/claude/`)
- **Codex config**: `codex/` (also `~/.config/codex/`)
- **Cursor config**: `cursor/`
- **Git config**: `git/config`, `git/ignore`
- **Fish config**: `fish/config.fish`, `fish/config/*.fish`, `fish/user_functions/*.fish`
- **Neovim**: `nvim/init.lua`, `nvim/lua/`
- **Karabiner**: `karabiner/karabiner.ts` (TypeScript source)
- **Wezterm**: `wezterm/wezterm.lua`
- **Ghostty**: `ghostty/config`
- **Aqua**: `aqua/aqua.yaml`
- **Nix**: `flake.nix`, `flake.lock`

## Additional Notes

- All English text (commits, docs, comments) should use **UK English spelling**
- System is **aarch64-darwin** (Apple Silicon Mac)
- XDG directories are properly configured
- Homebrew is managed via Nix configuration (automatic cleanup on activation)
- When stuck or need assistance, consider using Codex MCP for additional help
