# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a comprehensive dotfiles repository for macOS development environment configuration. It uses `rhysd/dotfiles` as the primary dotfiles manager and features extensive configurations for Neovim, Fish shell, and various development tools.

## Essential Commands

### Setup & Installation
```bash
# One-line installation
curl -L https://raw.githubusercontent.com/ryoppippi/dotfiles/main/setup.sh | sh

# Alternative using dotfiles tool
dotfiles clone ryoppippi
```

### Updating Tools
```bash
# Update Homebrew and Rust (Fish function)
update

# Update aqua-managed CLI tools
aqua install -l -a

# Update Fish plugins
fisher update
```

### Package Management

The repository uses a multi-layered package management approach:

1. **Homebrew** (`Brewfile`) - System packages, GUI apps, VS Code extensions
2. **aqua** (`aqua/aqua.yaml`) - CLI tools with version management (138+ tools)
3. **devbox** (`devbox/global/default/`) - Development environments
4. **Language-specific** - pnpm, bun, deno for JavaScript/TypeScript

## Repository Structure

Key directories and their purposes:
- `nvim/` - Modular Neovim configuration with 200+ plugins using lazy.nvim
- `fish/` - Fish shell configuration with custom functions and performance optimizations
- `karabiner/` - TypeScript-based keyboard customization
- `git/` - Git configuration and global ignore patterns
- `wezterm/` & `ghostty/` - Terminal emulator configurations

## Development Workflows

### Neovim Development
- Configuration is modular with language-specific setups in `nvim/after/lsp/`
- Custom commands available: `:Config`, `:ConfigTelescope`, `:ToggleStatusBar`
- Plugin configurations in `nvim/lua/plugin/`

### Fish Shell
- Custom functions in `fish/user_functions/`
- Abbreviations and aliases in `fish/config/abbrs_aliases.fish`
- Performance-optimized with configuration caching

### Git Workflow
- Currently on `nix` branch, main branch is `main`
- Dependency updates managed by Renovate bot
- Custom git configuration in `git/config`

## Important Notes

- The repository follows XDG Base Directory specification
- Heavy use of lazy loading and performance optimizations
- Extensive LSP configurations for multiple languages
- Integration with AI tools (Copilot, WakaTime)
- macOS-specific configurations and defaults