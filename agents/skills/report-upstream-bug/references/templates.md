# Templates

## Repro repository

Files: `README.md`, `LICENSE`, `.gitignore` (`node_modules`), `package.json` with exact pinned
versions, `packageManager` and `license`, the lockfile, the config, the smallest source files,
and a `repro.js` that exercises the code.

README headings, in this order:

1. Title naming the symptom, then one paragraph linking the upstream issue and the versions.
2. **Steps**: `install`, then the two scripts, plus the failing source in a code block.
3. **Expected**: what the baseline prints, plus the generated code that makes it work.
4. **Actual**: the error, and why.
5. **Analysis**: the hypothesis, the commit read, what was not verified.
6. **How it was found**: the real setup (framework, the override or swap used, what passed and
   what failed), without private names, and a line saying the framework is not needed to
   reproduce it.
7. **Files**: what the config switch does.

## Issue

Title: the symptom with the error text. Body headings: **What happens** (with the source),
**Cause** (generated code of baseline versus tool), **Analysis**, **Reproduction** (repo link and
the three commands), **Versions**, **How it was found**. Same text as the README sections, so
edit both together: write the shared sections once to a file and insert it into each.

Post and edit with `gh issue create` / `gh issue edit --body-file <file>`; keep the body in a
file, not an inline string.
