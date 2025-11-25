# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is ryoppippi's personal dotfiles repository. The repository includes configurations for Fish shell, Neovim, Karabiner-Elements, Wezterm, and various development tools. System configuration is managed via **Nix Flake** using nix-darwin (macOS) and home-manager (cross-platform).

## Nix Configuration Management

This repository uses **Nix Flake** for declarative system configuration on macOS (Apple Silicon) and Linux.

### Core Commands

```bash
# Apply Nix configuration changes
# IMPORTANT: Always git add changes before running switch to avoid warnings
git add .
nix run .#switch

# Update all flake dependencies
nix run .#update

# Update AI tools specifically
nix run .#update-ai-tools

# Test build without applying
nix run .#build
```

**Note**: Always stage (`git add`) Nix configuration changes before running `nix run .#switch` to avoid "uncommitted changes" warnings.

### Flake Structure

- **Main config**: `flake.nix` - Entry point defining inputs, outputs, and apps
- **Inputs**:
  - `nixpkgs` - Main package source
  - `nix-darwin` - macOS system configuration
  - `home-manager` - User environment management
  - `ai-tools` - AI development tools (codex, amp, cursor-agent, opencode, copilot-cli, coderabbit-cli)
  - `claude-code-overlay` - Claude Code package
  - `treefmt-nix` - Code formatting
  - `git-hooks` - Git hooks management
  - `gh-nippou` - GitHub daily report tool

- **Nix modules**: `nix/modules/`
  - `home/` - Cross-platform home-manager configuration
    - `default.nix` - Main home configuration
    - `packages.nix` - User packages
    - `dotfiles.nix` - Dotfile symlinks
    - `git-hooks.nix` - Git hooks configuration
    - `programs/` - Declarative program configurations (git, bat, ghostty, zed, jj, neovim, claude-code, codex, amp, cursor, gh, ai-tools)
  - `darwin/` - macOS-specific configuration
    - `system.nix` - nix-darwin system settings (Touch ID, Homebrew, etc.)
    - `packages.nix` - macOS-specific packages
    - `dotfiles.nix` - macOS-specific dotfile symlinks
    - `programs/` - macOS-specific program configurations (docker)
  - `linux/` - Linux-specific configuration
  - `lib/` - Shared helper functions

- **Overlays**: `nix/overlays/` - Custom package overlays

### Modifying Packages

1. Edit the appropriate Nix module:
   - Cross-platform packages: `nix/modules/home/packages.nix`
   - macOS-specific packages: `nix/modules/darwin/packages.nix`
   - Homebrew packages: `nix/modules/darwin/system.nix`
2. Run `nix run .#switch` to apply changes
3. If updating flake inputs, run `nix run .#update` first

### Package Management Hierarchy

- **Nix (preferred)**: Most CLI tools and development packages
- **Homebrew**: macOS-specific apps, casks, and tools not in nixpkgs

## Shell Environment (Fish)

Primary shell is Fish. Configuration is modularised:

- **Main config**: `fish/config.fish` - Loads all sub-configs from `fish/config/*.fish`
- **Functions**: `fish/user_functions/*.fish` - Custom Fish functions
- **Theme**: `fish/themes/kanagawa.fish`

### Key Environment Variables

- Editors: `EDITOR=nvim`, `GIT_EDITOR=nvim`, `MANPAGER=nvim`
- Claude Code: `CLAUDE_CONFIG_DIR=$XDG_CONFIG_HOME/claude`
- Codex: `CODEX_HOME=$XDG_CONFIG_HOME/codex`
- Amp: `AMP_HOME=$XDG_CONFIG_HOME/amp`
- XDG paths properly configured

### Path Configuration

Managed via `fish_add_path` in `fish/config.fish`. Includes Nix home-manager paths (line 79).

## Git Configuration

Git is configured declaratively via Home Manager in `nix/modules/home/programs/git/`.

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

### Git Hooks

Git hooks are managed declaratively through Nix in `nix/modules/home/git-hooks.nix`:

- **Pre-commit hook**: Automatically formats and lints staged files using treefmt
  - Runs `nix run .#fmt` on staged files
  - Includes nixfmt, stylua, and secretlint
  - Automatically re-adds formatted files to staging
  - Skips during rebase/merge/cherry-pick operations

- **Post-checkout/merge hooks**: Automatically applies Nix configuration changes
  - Triggers `nix run .#switch` when Nix-related files change
  - Monitors: `flake.nix`, `flake.lock`, `nix/`, `aqua/aqua.yaml`
  - Skips in CI environments
  - Skips when just restoring files (e.g., `git checkout -- file.txt`)

Hooks are automatically installed via Home Manager activation when running `nix run .#switch`.

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

- **Wezterm**: `wezterm/wezterm.lua` (with modular configs in `wezterm/`)
- **Ghostty**: Configured declaratively via Home Manager in `nix/modules/home/programs/ghostty.nix`

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

- **Main branch**: `main`
- **Branch protection**: Do not push to main directly without permission
- **Commit strategy**: Use git-commit-crafter skill for structured commits
- **Commit messages**: Must be in English with UK spelling
- **Conventional Commits**: Follow conventional commits specification

## File Locations

### Dotfiles in Repository
- **Fish config**: `fish/config.fish`, `fish/config/*.fish`, `fish/user_functions/*.fish`
- **Neovim**: `nvim/init.lua`, `nvim/lua/`
- **Karabiner**: `karabiner/karabiner.ts` (TypeScript source)
- **Wezterm**: `wezterm/wezterm.lua`
- **Hammerspoon**: `hammerspoon/init.lua`
- **Lazygit**: `lazygit/config.yml`
- **efm-langserver**: `efm-langserver/config.yaml`
- **OpenCode**: `opencode/opencode.jsonc`
- **Bash**: `bash/.bashrc`, `bash/.bash_profile`
- **Zsh**: `zsh/zshrc`, `zsh/zshenv`

### AI Tool Configs (symlinked to `~/.config/`)
- **Claude config**: `claude/`
- **Codex config**: `codex/`

### Nix Configuration
- **Main entry**: `flake.nix`, `flake.lock`
- **Modules**: `nix/modules/`
- **Overlays**: `nix/overlays/`

### Declarative Configs (managed by Home Manager)
These are configured in `nix/modules/home/programs/`:
- **Git**: `git/default.nix`, `git/aliases/`
- **Ghostty**: `ghostty.nix`
- **Bat**: `bat.nix`
- **Zed**: `zed.nix`
- **Jujutsu**: `jj.nix`
- **Amp**: `amp.nix`
- **Cursor**: `cursor.nix`

## Additional Notes

- All English text (commits, docs, comments) should use **UK English spelling**
- System is **aarch64-darwin** (Apple Silicon Mac)
- XDG directories are properly configured
- Homebrew is managed via Nix configuration (automatic cleanup on activation)
- When stuck or need assistance, consider using Codex MCP for additional help
