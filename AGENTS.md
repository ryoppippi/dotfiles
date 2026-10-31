# Dotfiles Repository

ryoppippi's personal dotfiles managed via **Nix Flake** (nix-darwin + home-manager).

## Core Commands

```bash
git add <changed paths> && nix run .#switch  # Apply changes
nix run .#update                             # Update dependencies
nix run .#build                              # Test build
```

Nix flakes only see tracked, staged files, so stage the paths you changed before `switch`.

## Layout Notes

- `agents/AGENTS.md` is the single global instruction file for every agent, with its sections in `agents/shared/`; skills live in `agents/skills/`. Use the `agent-instructions` skill before editing any of them.
- This repository keeps no `CLAUDE.md`: Claude Code loads this `AGENTS.md` through the built-in [`agents-md`](https://github.com/anthropics/claude-code/tree/main/mods/agents-md) plugin.
- `claude/` is symlinked to `~/.config/claude`, so edits there apply to the running Claude Code without a switch.
- Git and Ghostty are declarative under `nix/modules/home/programs/`; Fish and Neovim keep plain config in `fish/` and `nvim/`.
- Per-directory notes live in each directory's `README.md` (`nix/`, `fish/`, `nvim/`, `karabiner/`); read the relevant one before editing there.

## Scripting Language Choice

- **Nushell** — the default for any new script. Use the `nushell` skill.
- **Bun Shell or Python** — needs libraries.
- **Bash** — the environment is not ours: Nix build phases, `writeShellApplication`, bootstrap, git hooks.
- **Fish** — interactive config only (`fish/functions/`, abbreviations, completions), never a new script.

## Git Workflow

- This is a personal dotfiles repo — **committing and pushing directly to `main` is fine**, overriding the usual feature-branch rule. Do NOT open a pull request unless explicitly asked.
- Conventional Commits, UK English spelling.
