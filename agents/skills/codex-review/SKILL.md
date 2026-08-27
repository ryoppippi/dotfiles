---
name: codex-review
description: Run a code review using Codex or a native subagent. Use when the user wants a code review of uncommitted changes, a specific commit, or changes against a base branch.
---

Use the review path that matches the current session:

- Outside Codex: use `codex exec review`.
- Inside Codex (Desktop or CLI): delegate the review to a native subagent; do not start a nested Codex process.

## Scope

- Uncommitted changes: `--uncommitted` or the equivalent `git diff HEAD`.
- A branch: `--base <branch>` or `git diff <branch>...HEAD`.
- A commit: `--commit <sha>` or `git show <sha>`.

Ask when the requested scope is unclear. Return critical findings separately from suggestions, with file and line references.

## Codex CLI

```bash
codex exec review --uncommitted
codex exec review --base main --model <model-slug>
codex exec review --commit <sha> --model <model-slug>
codex exec review "Focus on error handling and edge cases"
```

The positional prompt cannot be combined with a scope flag. Run `codex exec review --help` when flags are unclear.

## Available Models

!`jq -r '.models[] | "- \(.slug): \(.description)"' "$CODEX_HOME/models_cache.json"`

Choose a Spark model for speed or the latest non-Spark model for deeper analysis.
