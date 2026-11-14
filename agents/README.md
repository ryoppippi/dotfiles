# Agent Instructions and Skills

Global instructions and skills shared by every coding agent (Claude Code, Codex, …).

- `AGENTS.md` — the global instruction file. Every Claude Code profile (`claudeProfiles` in `nix/modules/home/programs/claude-code/default.nix`) reads it as `CLAUDE.md` in its config directory (user-scope memory is only read under that name); its `@` imports resolve from `~/.config/claude/shared/`. Both are out-of-store symlinks, so edits apply without a switch. Codex gets `~/.codex/AGENTS.md`, generated at switch time with the fragments concatenated in (`nix/modules/home/programs/codex/default.nix`).
- `shared/` — the sections of `AGENTS.md`. A new fragment needs an `@` import in `AGENTS.md` and an entry in `sharedFragments` in the Codex module.
- `skills/` — local skills, enabled automatically by `nix/modules/home/agent-skills.nix` ([agent-skills-nix](https://github.com/Kyure-A/agent-skills-nix)) and deployed to `~/.agents/skills/` and each Claude profile's `skills/`. External skills are pinned in `../registry/sources/`.

How to write and maintain all of these: the `edit-skills` skill.
