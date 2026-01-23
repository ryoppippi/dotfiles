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
