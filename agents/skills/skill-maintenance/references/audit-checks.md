# Skill Audit Checks

The per-dimension checklist for `skill-maintenance`. The authoring rules these
checks enforce live in the `skill-creator` skill — read it for the _why_ and the
fix patterns; this file is the _what to verify_. `scripts/audit.sh` already
covers the countable parts (lengths, references/ and scripts/ presence); the rest
are judgement calls.

## Contents

- 1. Best-practices adherence
- 2. Name and description
- 3. Cross-skill duplication (link or merge)
- 4. Documentation and repo-file references
- 5. SKILL.md length and splitting

## 1. Best-practices adherence

Check each skill against Anthropic's best practices
(<https://platform.claude.com/docs/en/agents-and-tools/agent-skills/best-practices>):

- Body is procedural and concise — no explaining things the model already knows.
- Consistent terminology throughout (one term per concept).
- No time-sensitive content ("after August 2025…"); use an "old patterns" section instead.
- Examples are concrete, not abstract.
- One default per task, not a menu of options.
- Forward-slash paths only; no Windows backslashes.
- MCP tools referenced as `Server:tool_name`.
- Reference links are one level deep from SKILL.md (agents only preview nested files).

## 2. Name and description

- `name`: ≤ 64 chars, lowercase/numbers/hyphens, no `anthropic`/`claude`. (Hard-checked by the script.)
- `description`: ≤ 1024 chars hard limit, but **aim for ~20-35 words (~100-250 chars)**. The script flags > 350 — anything flagged should be trimmed unless every clause earns a trigger.
- Description must be **third person** and state both **what** the skill does and **when** to use it. Read each flagged or vague description and rewrite if it is first/second person, missing a trigger, or padded.
- The whole metadata set is preloaded into every session, so over-long descriptions tax all work, not just this skill.

## 3. Cross-skill duplication (link or merge)

The repo-wide check that single-skill authoring misses. For each pair of skills
that touch the same topic, pick the lightest fix (see `skill-creator` → "Overlap
between skills"):

- **Cross-link** when both skills stay distinct but overlap — replace the duplicated prose in one with a pointer to the other _by skill name_ (e.g. "Use the `tdd` skill when …"). One home for the detail, links from the rest.
- **Merge** only when two skills are genuinely the same workflow and neither earns its own trigger. Fold one in, delete the empty directory, and drop it from any allow-list.

How to find candidates:

```bash
# Pull every description into one view to spot overlapping triggers.
rg -N '^description:' agents/skills/*/SKILL.md

# Look for the same topic/command appearing across skills.
rg -l 'conventional commit' agents/skills    # e.g. commit vs create-commits-and-push vs create-pr
```

Report each overlap as: the two skills, whether to link or merge, and which one keeps the canonical content.

## 4. Documentation and repo-file references

For every skill, confirm it points at sources of truth instead of embedding copies:

- **Public docs**: a library/tool skill should carry the canonical docs URL.
- **Installed libraries**: if the skill targets a package in `node_modules/`, it should tell the agent to read the docs the package ships — `node_modules/<package-name>/README.md` or `node_modules/<package-name>/docs/**/*.md` — rather than restating the API. Background: <https://ryoppippi.com/blog/2025-12-14-publish-docs-on-npm-en>.
- **Relevant repo files** (local skills): if concrete files in this repo are the source of truth, the skill should name them by path (like `vitest-testing`'s "Key Files" section). Skim the repo for files the skill _should_ be pointing at but isn't.

Flag skills that paste doc/API content inline, hardcode values that drift from a real file, or omit an obvious local reference.

## 5. SKILL.md length and splitting

- The script flags `SKILL.md` > 150 lines (soft) and > 500 lines (hard).
- For each soft-flagged skill, decide whether to split: move runner/platform-specific guidance, long example galleries, failure playbooks, command catalogues, or large tables into `references/*.md`, leaving a one-line pointer that names the trigger. Model: `vitest-testing` (~50-line SKILL.md → ten `references/*.md`).
- Don't split content consulted on every run, or chunks < ~20 lines — the extra file read costs more than it saves.
- Hard violations (> 500) must be split.
