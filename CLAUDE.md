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

- `agents/shared/` fragments are imported by `claude/CLAUDE.md` and concatenated into Codex's `AGENTS.md` at switch time. Edit them once; never copy text between the two.
- `claude/` is symlinked to `~/.config/claude`, so edits there apply to the running Claude Code without a switch.
- Git and Ghostty are declarative under `nix/modules/home/programs/`; Fish and Neovim keep plain config in `fish/` and `nvim/`.

## Scripting Language Choice

- **Nushell** — the default for any new script. Use the `nushell` skill.
- **Bun Shell or Python** — needs libraries.
- **Bash** — the environment is not ours: Nix build phases, `writeShellApplication`, bootstrap, git hooks.
- **Fish** — interactive config only (`fish/functions/`, abbreviations, completions), never a new script.

## Git Workflow

- This is a personal dotfiles repo — **committing and pushing directly to `main` is fine**. This is an explicit exception to the global commit skill's main-branch rule. Do NOT open a pull request unless explicitly asked.
- Conventional Commits, UK English spelling.

## External Skills (agent-skills-nix)

Skills are managed via [agent-skills-nix](https://github.com/Kyure-A/agent-skills-nix) in `nix/modules/home/agent-skills.nix`. External skill repositories are pinned in `registry/sources/`, not as flake inputs. Local skills live in `agents/skills/` and are enabled automatically — see the `skill-creator` skill.

### Adding a new external skill

1. Add a pin manifest `registry/sources/my-skill.nix`:
   ```nix
   {
     pin = {
       type = "github";
       owner = "owner";
       repo = "repo";
       branch = "main";
     };

     subdir = "path/to/skills";
     idPrefix = "my-skill";
     filter.maxDepth = 1;
   }
   ```
2. Resolve the pin: `nix run .#skills-sources-lock`
3. Select the skill in `agent-skills.nix` — `skills.explicit.<id>` when it needs
   `packages` or a `transform`, otherwise add its prefixed catalog ID to
   `skills.enable`
4. Run `git add registry/ nix/modules/home/agent-skills.nix && nix run .#switch`

Updating external skills is the same lock-then-switch pair. Editing a manifest
without regenerating the lock fails evaluation, so the two always stay in sync.
