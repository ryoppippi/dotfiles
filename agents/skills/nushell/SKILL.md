---
name: nushell
description: 'When writing, reviewing, or porting a shell script, a `.nu` file, or a `shell: nu {0}` CI step.'
---

# Nushell

Nushell is a functional language over structured data that happens to be a
shell. Write pipelines of transformations over records and tables, not bash with
different syntax: data stays structured end to end, so there is no `jq`, `sed`,
`awk`, or `date` to install or write twice for macOS and Linux.

## Before and after writing

1. Read the docs for the topic first. Start from these; their sidebar reaches
   every book page, `/commands/`, `/cookbook/`, and `/lang-guide/`:
   - https://www.nushell.sh/book/thinking_in_nu.html
   - https://www.nushell.sh/book/nushell_map_functional.html
   - https://www.nushell.sh/book/coming_to_nu.html
   - https://www.nushell.sh/book/style_guide.html
2. Verify every construct against the installed version — Nushell renames and
   breaks commands between minor releases, so memory is not enough:
   `nu --version`, `nu -c '<snippet>'`, `nu -c 'help <command>'`,
   `nu --ide-check 10 <file>`.
3. Format with `nufmt <file>` (`--dry-run` to check).

## Style

Write it functionally. In review, these signal bash habits:

- `mut` plus `for` as an accumulator, where `reduce`, `each`, `where`,
  `group-by`, `zip`, or `generate` expresses it.
- Text passed between steps instead of records; serialise once at the boundary
  and parse external output (`from json`) immediately.
- Nested `if` chains on a value's shape instead of `match`.
- Shelling out to `^jq`, `^sed`, `^awk`, or `^date`, or reimplementing a
  builtin filter.

Give scripts a `def main`, type command signatures, keep times as `datetime` and
`duration` rather than strings, and fail with `error make` rather than a
sentinel value.

## In this repository

- CI steps use `shell: nu {0}` with `hustcer/setup-nu` and an explicit pinned
  `version:`; see `.github/workflows/_update-flake-reusable.yaml`.
- Standalone scripts live beside their consumer, e.g.
  `nix/packages/git-wtpr/git-wtpr.nu`.
- `nu` and `nufmt` are not on the interactive PATH; use the `missing-tools`
  skill.
