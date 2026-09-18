# Agent Skills

Shared skills for AI agents (Claude Code, Codex, etc.) managed via [agent-skills-nix](https://github.com/Kyure-A/agent-skills-nix).

## Global Instructions (`AGENTS.md` and `shared/`)

`agents/AGENTS.md` is the single global instruction file for every agent — there is no per-agent copy and no `CLAUDE.md` anywhere in this repository. Its sections are kept as fragments in `agents/shared/*.md` and pulled in with `@` imports:

- **Claude Code**: `agents/AGENTS.md` is symlinked to `~/.config/claude/CLAUDE.md` and `agents/shared/` to `~/.config/claude/shared/` (`nix/modules/home/programs/claude-code/default.nix`). User-scope memory is only read under the name `CLAUDE.md`; project-scope `AGENTS.md` files are read by the built-in [`agents-md`](https://github.com/anthropics/claude-code/tree/main/mods/agents-md) plugin. Both are out-of-store symlinks, so edits apply without a switch.
- **Codex**: `~/.codex/AGENTS.md` is generated at switch time by dropping the `@` imports and concatenating the fragments (`nix/modules/home/programs/codex/default.nix`). A new fragment must be added to both the import list and `sharedFragments` there.

Edit the fragments here, never the deployed copies. Codex picks up changes only after `nix run .#switch`.

## Configuration

Skills are configured in `nix/modules/home/agent-skills.nix` and deployed to:

- `~/.config/claude/skills/`
- `~/.codex/skills/`

## Adding a New Skill

1. Create a directory with a `SKILL.md` file
2. Enable it in `agent-skills.nix`:
   ```nix
   skills.enable = [ "my-skill" ];
   ```
3. Run `git add skills/<my-skill> ../nix/modules/home/agent-skills.nix && nix run .#switch`

## Skill Design Guidelines

### Dynamic Context with Command Substitution

Use `` !`command` `` syntax to inject dynamic context inline. Embed it naturally in text rather than creating separate sections.

**Example:**

```markdown
**Current branch:** `!\`git branch --show-current\``

**Version:**`!\`tool --version 2>/dev/null || echo "not installed"\``
```

**Dynamic:** current state, CLI help, environment info
**Static:** workflow steps, best practices, examples

Reference: https://code.claude.com/docs/en/skills#inject-dynamic-context
