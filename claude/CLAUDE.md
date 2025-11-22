- My name is ryoppippi
- when you create a git commit, use the git-commit-crafter skill. Keep the commit as tiny as possible and git message as detailed as possible. However each commits should be meaningful and not just a single line change. you can use git hunk to selectively commit changes.
- you must use English for all commit messages, code comments, documentation, PR body, PR title, etc. but you can talk to me in any language.
- **IMPORTANT**: Use UK English spelling as much as possible in all English text (e.g. "colour", "organise", "analyse", "behaviour", "honour", "initialise", "realise", "recognise", "specialise", "summarise", "utilise", etc.)
- if you failed running a command, you can also try fish shell like `fish -c <command>`
- **IMPORTANT**: Do not push to main branch directly without permission. You need to consider creating a new branch for your changes and then create a PR to merge it into main branch.
- if you failed running `bunx <command>`, you can try `bun x <command>` instead.

Instead of ordinary tools, you can use the tools below which are already installed and achieved high performance:
- fish - bash replacement
- git
- gh - GitHub CLI
- rg - grep replacement
- fd - find replacement
- bat - cat replacement with syntax highlighting
- eza - ls replacement with git integration
- dust - disk usage analyser
- typos - spell checker
- bunx - replacement for npx
- jq - JSON processor

Also, you may have codex mcp. codex is a ai agent. if you are stuck, you can ask codex for help.
Codex is:
- capable of writing code in multiple programming languages
- capable of analysing code and finding bugs
- capable of searching the web for information (really good)

**IMPORTANT**: When you need to analyze codebase structure or search for specific code patterns, use the ast-grep skill instead of ordinary grep/rg tools.

use ast-grep skill to analyse your codebase

## Nix Configuration Structure

This dotfiles repository uses a modular Nix configuration:

- **`flake.nix`** - Main entry point
  - Defines inputs (nixpkgs, nix-darwin, home-manager, etc.)
  - Imports modules from `nix/` directory
  - Defines apps for switch/build/update commands
  - Supports both macOS (darwinConfigurations) and Linux (homeConfigurations)

- **`nix/home.nix`** - Home Manager configuration (cross-platform)
  - Manages dotfiles via `home.file` with `mkOutOfStoreSymlink`
  - All dotfiles symlinks point to `${dotfilesDir}` (defaults to `${homedir}/ghq/github.com/ryoppippi/dotfiles`)
  - User package list
  - Platform-specific packages via `pkgs.stdenv.isDarwin`

- **`nix/darwin.nix`** - macOS system configuration (nix-darwin only)
  - System settings (Touch ID, fish shell, etc.)
  - Homebrew configuration (taps, brews, casks, masApps)

- **`nix/overlays.nix`** - Package overlays
  - AI tools from numtide/nix-ai-tools
  - Claude Code from claude-code-overlay

### When modifying Nix configuration:
- Add/remove packages: edit `nix/home.nix`
- Add/remove Homebrew packages (macOS): edit `nix/darwin.nix`
- Add new dotfile symlinks: add to `home.file` in `nix/home.nix`
- System settings (macOS): edit `nix/darwin.nix`
- After changes: run `nix run .#switch` to apply

### Dotfiles Management:
- All dotfiles are managed via Home Manager's `home.file` configuration
- No separate dotfiles CLI is used (removed rhysd/dotfiles)
- Symlinks are automatically created/updated on `nix run .#switch`
- Dotfiles remain mutable in the repository
