---
name: skill-creator
description: Guides agent-skill creation and updates following Anthropic's SKILL.md best practices. Use when adding or editing skills under `agents/skills/`, writing SKILL.md frontmatter, references, or skill routing.
---

# Skill Creator

Use this skill when creating or updating local skills under `agents/skills/` in this dotfiles repo. They are deployed to `~/.agents/skills/` and `~/.config/claude/skills/` via `nix/modules/home/agent-skills.nix` (auto-enabled by `skills.enableAll = [ "local" ]`).

## Workflow

1. Decide whether a new skill is needed. Add one only when repeated work needs a specialised workflow, local references, command sequences, or policy that should trigger on demand. Otherwise extend an existing skill.
2. Create or update `agents/skills/<skill-name>/SKILL.md` with YAML frontmatter and concise Markdown.
3. Keep `SKILL.md` focused on workflow and navigation. Move detailed examples, APIs, or long checklists into `references/*.md` linked directly from `SKILL.md`.
4. Add scripts under `scripts/` for deterministic, repeated, or fragile operations — see the **Scripts** section below for when a script beats inline commands.
5. Stage only the skill directory and deploy: `git add agents/skills/<skill-name> && nix run .#switch`. Avoid `git add .` so unrelated working-tree changes (especially `nix/modules/home/programs/codex.nix`, which can contain private repo names) are not picked up. `agent-skills.nix` enables every directory under `local` automatically — no allow-list edit needed.

## Frontmatter

Required fields (see `https://docs.claude.com/en/docs/agents-and-tools/agent-skills/best-practices`):

```yaml
---
name: skill-name
description: One or two sentences. What the skill does and when to use it.
---
```

Constraints:

- `name`: max 64 chars, lowercase letters / numbers / hyphens only, no `anthropic` or `claude`.
- `description`: max 1024 chars, non-empty, **third person**, no XML tags. Include both **what** and **when**. Frontmatter is always loaded, so keep it tight — aim for ~20-35 words (~100-250 chars).

Good:

```yaml
description: Creates atomic Conventional Commits. Use when committing code changes, splitting hunks into revertable units, or writing detailed commit messages.
```

Bad:

```yaml
# Vague
description: Helps with commits.
# First person
description: I can help you write commits.
# Way too long, no clear trigger
description: This skill is a comprehensive commit assistant that analyses changes and produces beautifully formatted commit messages following all the best practices...
```

## Body

Keep the body procedural and repo-specific:

- Commands to run, with exact flags.
- Files or references to read.
- Local conventions that are easy to miss.
- Validation expected after changes.
- Small good/bad examples that prevent common mistakes.

Avoid explaining generic concepts the model already knows. Aim for under 500 lines; split larger content into `references/`.

## Documentation references

Don't paste large chunks of external docs into the skill — they go stale and cost tokens. Point at the authoritative source instead:

- **Public docs**: include the canonical docs URL (e.g. `https://vitest.dev/api/`) so the agent can fetch the current version when needed.
- **Installed libraries**: if the skill is about a package present in `node_modules/`, instruct the agent to read the docs the package ships locally — they match the installed version and need no network. Many packages now publish docs on npm for exactly this (see <https://ryoppippi.com/blog/2025-12-14-publish-docs-on-npm-en>).

  ```markdown
  For API details, read `node_modules/<package-name>/README.md`
  (or `node_modules/<package-name>/docs/**/*.md` if the package ships a docs folder).
  ```

  Find them with `fd README.md node_modules/<package-name>` or `fd -e md . node_modules/<package-name>/docs`.

- **Relevant repo files** (local skills only): if concrete files in this repo are the source of truth for the skill, list them by path so the agent reads the real thing instead of a stale copy. The `vitest-testing` skill's **Key Files** section is the model — it names `vitest.setup.ts`, `test-db.ts`, etc. by path.

## Overlap between skills

When two skills cover related ground, prefer the lightest fix that removes the duplication:

1. **Cross-link** — if each skill is still distinct but they touch, link them by name rather than copying text. E.g. `vitest-testing` says "Use the `tdd` skill when …". The shared detail lives in one skill; the other points to it.
2. **Merge** — only when the skills are genuinely the same workflow and neither earns its own trigger. Fold one into the other and delete the empty directory.

Never paste the same instructions into two skills — pick a single home and link to it.

## Dynamic context

Use `` !`command` `` inside fenced blocks to inject live state (current branch, tool version, detected test runner). Prefer dynamic blocks for environment info; keep static text for workflow steps and best practices.

Reference: <https://code.claude.com/docs/en/skills#inject-dynamic-context>

## References

Two thresholds for `SKILL.md` length:

- **~150 lines — consider splitting.** Once the body passes this, it is usually no longer a tight, scannable workflow. Move conditional or long-form detail into `references/*.md`. The `vitest-testing` skill is the model: a ~50-line `SKILL.md` that routes to ten focused `references/*.md` files.
- **~500 lines — hard ceiling** (Anthropic guidance). Never exceed this; split aggressively before you get here.

Reference files load only when the agent follows the link, so splitting keeps the always-loaded surface small without losing detail.

```text
agents/skills/example-skill/
├── SKILL.md
└── references/
    ├── api.md
    └── examples.md
```

### When to split into references

Split content out as soon as it stops being needed on every run of the skill. Concrete triggers:

- **Runner / platform-specific guidance** — e.g. Vitest vs Rust vs Zig examples for the `tdd` skill. The main SKILL.md keeps the universal cycle; each runner file is loaded only for that stack.
- **Long good/bad example galleries** — keep one representative example inline, push the rest to `references/examples.md`.
- **Failure-recovery and edge-case playbooks** — e.g. `references/git-apply.md` for patch-staging recovery: only read when the happy path fails.
- **Command catalogues** — long lists of `gh` / `git` invocations belong in `references/<topic>-commands.md`, with the main file linking by purpose.
- **Templates, schemas, or large tables** — anything > ~30 lines that the agent only needs as a lookup.

Stop splitting when:

- The detail is consulted on every invocation (keep it inline).
- A reference would be < ~20 lines (just inline it — the extra file read costs more than the tokens it saves).

### How to split

1. Identify a self-contained section in `SKILL.md`.
2. Move it verbatim to `references/<topic>.md`. Give it an H1 and, if > 100 lines, a contents list at the top so partial reads (`head -100`) still surface the scope.
3. Replace the original location with a one-line pointer that names the trigger condition: e.g. `When a patch fails or needs whitespace handling, read references/git-apply.md.`
4. Link reference files **directly from `SKILL.md`**. Keep links one level deep — agents may only preview nested references.
5. Prefer `references/<topic>.md` over top-level `<topic>-example.md`; the dedicated folder makes the boundary obvious and is the convention used across this repo and the ccusage skills.

## Scripts

When an operation is deterministic and repeated, add a script under `scripts/` — it is executed, not loaded, so only its stdout costs tokens. For when to use one and the rules (execution intent, shebangs, error handling, no magic constants), read [`references/scripts.md`](references/scripts.md).

## Token budget

Skill metadata (name + description across all skills) is preloaded into the system prompt. If Codex or Claude reports descriptions were trimmed to fit the skills context budget, shorten descriptions first, then disable unused skills in `agent-skills.nix`.
