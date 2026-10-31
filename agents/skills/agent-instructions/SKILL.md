---
name: agent-instructions
description: When adding, editing, renaming, or auditing skills in `agents/skills/`, the global `agents/AGENTS.md` and its `agents/shared/` fragments, or a repository's `AGENTS.md`.
---

# Agent Instructions

Global instructions and every skill's name and description load into every
session; skill bodies load only when chosen. Every line has to earn that cost.

## Principles

- Write intent and judgement, not rule lists. Narrow micro-rules get followed to
  the letter and gamed at the edges; a stated purpose generalises. Before adding
  a rule after one bad outcome, look for its cause: missing context, a
  misleading instruction, or a missing tool.
- Prefer tooling to prose. A rule a lint, hook, formatter, or script can enforce
  belongs there; delete the sentence.
- One home per fact. Link another skill by name instead of copying it, and never
  restate the global instructions in a skill.
- Point at sources of truth — docs URLs, `<tool> --help`,
  `node_modules/<package>/README.md`, repo files by path — instead of
  transcribing them. Copies go stale.
- Leave out what the model already knows.

## Skills

- The `name` (and directory) says what the skill is about:
  `nix-github-rate-limit`, not `helper`. Lowercase and hyphens, at most 64
  characters.
- The `description` says only **when** to read the skill, in one short
  sentence: `When committing changes or writing a commit message.` Agents pick
  skills from the name and description alone, so a content summary there costs
  tokens in every session and blurs the trigger.
- Keep `SKILL.md` a short workflow. Move detail only some runs need into
  `references/<topic>.md`, linked directly from `SKILL.md` with the condition for
  reading it.
- Put deterministic, fragile, or repeated operations in `scripts/` and write
  "Run `scripts/<name>`"; only their output costs context.
- `` !`command` `` injects live state (current branch, PR checks) when the
  skill loads: https://code.claude.com/docs/en/skills#inject-dynamic-context
- Add a skill only for repeated work that needs specialised steps or local
  facts; otherwise extend an existing one. Delete a skill that no longer earns
  its trigger.

Background: https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices

## In This Repository

- Local skills in `agents/skills/<name>/` are enabled automatically by
  `nix/modules/home/agent-skills.nix` and deployed to `~/.agents/skills/` and
  `~/.config/claude/skills/`. A skill that needs packages or a transform also
  has a `skills.explicit.<name>` entry there.
- Renaming a skill means updating every reference:
  `rg -n '<old-name>' --hidden -g '!.git'`. Besides other skills and
  `agents/`, the Claude Code hook in
  `nix/modules/home/programs/claude-code/default.nix` matches the
  `cross-model-review` skill by name.
- A new `agents/shared/` fragment needs an `@` import in `agents/AGENTS.md` and
  an entry in `sharedFragments` in `nix/modules/home/programs/codex/default.nix`.
- Deploy by staging the changed paths, then `nix run .#switch`.

### External Skills

External skill repositories are pinned in `registry/sources/`, not as flake
inputs.

1. Add a pin manifest, e.g. `registry/sources/my-skill.nix`:
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
2. Resolve it with `nix run .#skills-sources-lock`. A manifest without a
   regenerated lock fails evaluation, so always run the two together; updating
   pins is the same pair.
3. Select the skill in `agent-skills.nix`: `skills.explicit.<id>` when it needs
   `packages` or a `transform`, otherwise its prefixed catalogue ID in
   `skills.enable`.
4. `git add registry/ nix/modules/home/agent-skills.nix && nix run .#switch`

## Auditing the Collection

1. Run `scripts/audit.nu` for SKILL.md lengths and frontmatter limits.
2. Read every name and description together —
   `rg -N '^(name|description):' agents/skills/*/SKILL.md` — and look for
   overlapping triggers (merge, or cross-link by name), descriptions that
   summarise instead of saying when, and vague names.
3. Read each body for stale paths and commands, copied docs, duplicated global
   rules, and micro-rules that tooling could enforce.
4. Report one line per finding (skill, issue, fix), then fix.

If an agent reports that skill descriptions were trimmed to fit its context
budget, shorten descriptions first, then disable unused skills.
