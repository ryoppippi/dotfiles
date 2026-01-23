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
├── agents/skills/      # Shared AI agent skills (Claude, Codex)
├── claude/             # Claude Code config (user memory)
└── .claude/rules/      # Path-specific rules
```

## Dotfiles Locations

| Config    | Location                                | Notes                                        |
| --------- | --------------------------------------- | -------------------------------------------- |
| Fish      | `fish/`                                 | Modular config in `fish/config/`             |
| Neovim    | `nvim/`                                 | Lua-based, uses Lazy.nvim                    |
| Karabiner | `karabiner/`                            | TypeScript source, see `karabiner/CLAUDE.md` |
| Wezterm   | `wezterm/`                              | Lua config                                   |
| Git       | `nix/modules/home/programs/git/`        | Declarative via Home Manager                 |
| Ghostty   | `nix/modules/home/programs/ghostty.nix` | Declarative                                  |

## Git Workflow

- **Main branch**: `main`
- **Never push to main directly** - create a PR
- Use **Conventional Commits** with UK English spelling
- Commits are GPG-signed with SSH

## External Skills (agent-skills-nix)

Claude Code skills are managed via [agent-skills-nix](https://github.com/Kyure-A/agent-skills-nix).

Configuration: `nix/modules/home/agent-skills.nix`

### Adding a new external skill

1. Add flake input in `flake.nix`:
   ```nix
   my-skill = {
     url = "github:owner/repo";
     flake = false;
   };
   ```
2. Add source in `agent-skills.nix`:
   ```nix
   sources.my-skill = {
     path = my-skill;
     subdir = "path/to/skills";
   };
   ```
3. Enable the skill:
   ```nix
   skills.enable = [ "skill-id" ];
   ```
4. Run `git add . && nix run .#switch`

### Adding a local skill

Create a new skill directory in `agents/skills/` with a `SKILL.md` file, then enable it in `agent-skills.nix`.

### Updating external skills

```bash
nix flake update ast-grep-skill  # Update specific skill
nix run .#switch                  # Apply changes
```

### Current skills

**External:**

- **ast-grep**: [ast-grep/claude-skill](https://github.com/ast-grep/claude-skill)

**Local (in `agents/skills/`):**

- git-commit-crafter
- pr-workflow-manager

## System Info

- **Platform**: aarch64-darwin (Apple Silicon)
- **Shell**: Fish
- **Editor**: Neovim
