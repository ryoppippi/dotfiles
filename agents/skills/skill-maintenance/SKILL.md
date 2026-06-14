---
name: skill-maintenance
description: Audits all local skills in this repo for skill-creator and Anthropic best-practice compliance. Use to review the whole skill collection — checking descriptions, SKILL.md length, cross-skill duplication, and documentation references — not to author a single skill.
---

# Skill Maintenance

Repo-wide health check for the skills under `agents/skills/`. Where the
`skill-creator` skill authors or edits **one** skill, this skill reviews and
optimises the **whole collection** at once: every `SKILL.md`, plus the
relationships between skills (duplication, merge/link opportunities).

The authoring conventions being enforced all live in `skill-creator` — this skill
does not restate them. It is the auditor; `skill-creator` is the rulebook.

## Workflow

Copy this checklist and work through it:

```
Skill audit:
- [ ] 1. Run scripts/audit.sh for the mechanical pass
- [ ] 2. Audit each flagged skill against references/audit-checks.md
- [ ] 3. Cross-skill duplication pass (link or merge)
- [ ] 4. Documentation & repo-file references pass
- [ ] 5. Report findings, then fix with confirmation
```

**1. Mechanical pass.** Run the script — it lists every skill with its SKILL.md
line count, name/description lengths, and references/ + scripts/ presence,
flagging hard violations with `!`:

```bash
agents/skills/skill-maintenance/scripts/audit.sh
```

**2. Per-skill audit.** For each skill the script flagged (and spot-check the
rest), apply the criteria in
[`references/audit-checks.md`](references/audit-checks.md): best-practice
adherence, name/description quality, and SKILL.md length/splitting.

**3. Cross-skill duplication.** This is the check single-skill authoring cannot
do. Compare skills that touch the same topic and decide, per the
"Cross-skill duplication" section of the reference, whether to **cross-link** them
by name or **merge** them. Find candidates with:

```bash
rg -N '^description:' agents/skills/*/SKILL.md   # overlapping triggers
```

**4. References pass.** Confirm each skill points at sources of truth — docs URLs,
`node_modules/<package>/README.md` for library skills, and named repo files for
local skills — instead of pasting copies. See the reference's "Documentation and
repo-file references" section.

**5. Report and fix.** Summarise findings as a per-skill list (issue → proposed
fix). Apply fixes following `skill-creator`, then re-run `scripts/audit.sh` to
confirm the mechanical flags clear. Deploy as `skill-creator` describes
(stage only the skill dirs, then `nix run .#switch`).

## Scope

In scope: structure, metadata, duplication, references, length. Out of scope:
rewriting a skill's domain logic — that is ordinary editing via `skill-creator`.
