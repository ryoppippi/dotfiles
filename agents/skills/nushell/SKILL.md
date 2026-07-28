---
name: nushell
description: Write idiomatic, functional Nushell — the default language for shell scripts here. Use when writing or reviewing any new script, .nu files, `shell: nu {0}` CI steps, or when porting bash/POSIX shell to Nushell.
---

# Nushell

Nushell is a functional, structured-data language that happens to be a shell. Write it that way: pipelines of transformations over records and tables, not bash with different syntax.

## Why Nushell

Functional over structured data: JSON, `ls`, and command output stay records through the whole pipeline instead of being re-parsed as text. So no `jq`/`sed`/`awk`/`date` to install, wrap, or write twice for macOS and Linux — and Nix pins the interpreter.

Which language to pick for a given script is in the repo's `CLAUDE.md`.

## Steps

1. Read the docs for the topic at hand (see below) before writing any Nushell.
2. Write the code functionally — see Rules.
3. Verify every construct against the installed version before claiming it works. Nushell breaks and renames things between minor releases, so do not trust memory of a command's signature:
   ```sh
   nu --version
   nu -c '<snippet>'          # run a snippet
   nu --ide-check 10 <file>   # parse/typecheck a script
   nu -c 'help <command>'     # check a signature
   ```
4. Format before committing:
   ```sh
   nufmt <file>             # rewrites in place
   nufmt --dry-run <file>   # non-zero exit if it would change
   ```

## Docs

Read before writing:

- https://www.nushell.sh/book/thinking_in_nu.html
- https://www.nushell.sh/book/nushell_map_functional.html
- https://www.nushell.sh/book/nushell_map_imperative.html
- https://www.nushell.sh/book/coming_to_nu.html
- https://www.nushell.sh/book/style_guide.html

Every page of the book is in the sidebar of those, as are `/commands/`, `/cookbook/`, and `/lang-guide/`. Follow the sidebar to whatever the task needs instead of guessing.

## Rules

Functional style is the default. In review, treat each of these as a defect to fix:

- **`mut` + `for` as an accumulator.** Replace with `reduce`, `each`, `where`, `group-by`, `zip`, `flatten`, `insert`/`update`, `generate`. `mut` is legitimate only for genuinely sequential state that no filter expresses.
- **String plumbing between steps.** Pass records and tables. Serialise once at the boundary (`to json --raw`), parse once on the way in (`from json`).
- **Nested `if`/`else` chains on a value's shape.** Use `match`, including list patterns (`[]`, `[$first, ..$rest]`) and guards.
- **Reimplementing a builtin.** Check `https://www.nushell.sh/commands/categories/filters.html` first.
- **Shelling out for data.** Prefer native commands over `^jq`, `^sed`, `^awk`, `^date`. When an external command is genuinely needed, pipe its output through `from json` etc. immediately.
- **Bare `each` for effects.** If the result is unused, say so with `| ignore`; if it produces values, keep them in the pipeline.

Also:

- Give every script a `def main`.
- Type custom command signatures — parameter types, `--flag`, and the return type. They document intent and are checked at parse time. `nufmt` strips a redundant `: any`; leave it stripped.
- Timestamps are `datetime`, durations are `duration`. Compare and subtract them directly instead of formatting to strings. Convert explicitly to UTC (`| date to-timezone UTC`) when the value crosses a boundary that expects it.
- Fail loudly with `error make` rather than returning a sentinel value.

## In this repo

- CI workflow steps run Nushell via `shell: nu {0}` with `hustcer/setup-nu`. See `.github/workflows/_update-flake-reusable.yaml` for the established style.
- Pin the interpreter. Workflows pass an explicit `version:` to `setup-nu`; keep doing that, or a Nushell release will break a script that never changed.
- Standalone scripts live alongside their consumer, e.g. `nix/packages/git-wtpr/git-wtpr.nu`.
- Neither `nu` nor `nufmt` is on the interactive PATH; use the `missing-tools` skill to reach them.
