# Skill Audit Checks

What to verify, per dimension. Every rule being enforced lives in the
`skill-creator` skill — read the named section there for the rule and its fix
pattern, and judge the skill against it. `scripts/audit.nu` already covers the
countable parts (lengths, `references/` and `scripts/` presence); everything here
is a judgement call.

## Contents

- 1. Body and best practices
- 2. Name and description
- 3. Cross-skill duplication (link or merge)
- 4. Documentation and repo-file references
- 5. SKILL.md length and splitting

## 1. Body and best practices

Against `skill-creator` → "Body". The violations worth reading for, because the
script cannot see them: inconsistent terminology, time-sensitive wording,
abstract examples, a menu of options where one default belongs, backslash paths,
MCP tools not written as `Server:tool_name`, and reference links more than one
level deep.

## 2. Name and description

Against `skill-creator` → "Frontmatter". Read every description the script
flagged, plus any that reads vaguely, and rewrite it if it is not third person,
does not say both what and when, or pads without earning a trigger.

## 3. Cross-skill duplication (link or merge)

The repo-wide check single-skill authoring cannot do. Decide link vs merge per
`skill-creator` → "Overlap between skills".

Find candidates:

```bash
# Overlapping triggers, all descriptions in one view.
rg -N '^description:' agents/skills/*/SKILL.md

# The same topic or command appearing across skills.
rg -l 'conventional commit' agents/skills    # e.g. commit vs create-commits-and-push vs create-pr
```

Report each overlap as: the two skills, link or merge, and which one keeps the
canonical content.

## 4. Documentation and repo-file references

Against `skill-creator` → "Documentation references". Flag skills that paste doc
or API content inline, transcribe a CLI's flags instead of pointing at its
`--help`, hardcode values that drift from a real file, or miss an obvious local
source of truth. Skim the repo for files a skill _should_ name but does not.

## 5. SKILL.md length and splitting

Against `skill-creator` → "References". The script raises a soft flag past 150
lines and a hard one past 500. For each soft flag decide whether the body still
reads as one tight workflow; hard flags must be split.

## Reporting

One line per finding: skill, issue, proposed fix. Group by skill, most severe
first, so the fix pass can be worked top to bottom.
