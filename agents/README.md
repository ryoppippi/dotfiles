# Agent Skills

Shared skills for AI agents (Claude Code, Codex, etc.) managed via [agent-skills-nix](https://github.com/Kyure-A/agent-skills-nix).

## Configuration

Skills are configured in `nix/modules/home/agent-skills.nix` and deployed to:

- `~/.config/claude/skills/`
- `~/.config/codex/skills/`

## Adding a New Skill

1. Create a directory with a `SKILL.md` file
2. Enable it in `agent-skills.nix`:
   ```nix
   skills.enable = [ "my-skill" ];
   ```
3. Run `git add . && nix run .#switch`

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
