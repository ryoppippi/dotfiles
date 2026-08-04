# Splitting a SKILL.md into references

Read this once a `SKILL.md` passes ~150 lines, or when deciding whether a section
earns its own file.

```text
agents/skills/example-skill/
├── SKILL.md
└── references/
    ├── api.md
    └── examples.md
```

Reference files load only when the agent follows the link, so splitting keeps the
always-loaded surface small without losing detail.

## When to split

Split content out as soon as it stops being needed on every run of the skill. Concrete triggers:

- **Runner / platform-specific guidance** — e.g. Vitest vs Rust vs Zig examples for the `tdd` skill. The main SKILL.md keeps the universal cycle; each runner file is loaded only for that stack.
- **Long good/bad example galleries** — keep one representative example inline, push the rest to `references/examples.md`.
- **Failure-recovery and edge-case playbooks** — e.g. `references/git-apply.md` for patch-staging recovery: only read when the happy path fails.
- **Command catalogues** — long lists of `gh` / `git` invocations belong in `references/<topic>-commands.md`, with the main file linking by purpose.
- **Templates, schemas, or large tables** — anything longer than ~30 lines that the agent only needs as a lookup.

Stop splitting when:

- The detail is consulted on every invocation (keep it inline).
- A reference would be under ~20 lines (just inline it — the extra file read costs more than the tokens it saves).

## How to split

1. Identify a self-contained section in `SKILL.md`.
2. Move it verbatim to `references/<topic>.md`. Give it an H1 and, if it runs past 100 lines, a contents list at the top so partial reads (`head -100`) still surface the scope.
3. Replace the original location with a one-line pointer that names the trigger condition: e.g. `When a patch fails or needs whitespace handling, read references/git-apply.md.`
4. Link reference files **directly from `SKILL.md`**. Keep links one level deep — agents may only preview nested references.
5. Prefer `references/<topic>.md` over top-level `<topic>-example.md`; the dedicated folder makes the boundary obvious and is the convention used across this repo and the ccusage skills.
