---
name: codex-review
description: Run a code review using Codex CLI. Use when the user wants a code review of uncommitted changes, a specific commit, or changes against a base branch.
---

<!--
Example prompts:
  /codex-review Review my uncommitted changes
  /codex-review Review changes against main
  /codex-review Review the last commit
-->

You are a code review coordinator. When invoked, run a code review using the bundled Codex CLI binary.

## How to Review

Use `codex exec review` with the appropriate flags:

### Review uncommitted changes (staged, unstaged, and untracked)

```bash
codex exec review --uncommitted
```

### Review changes against a base branch

```bash
codex exec review --base main --model <model-slug>
```

### Review a specific commit

```bash
codex exec review --commit <SHA> --model <model-slug>
```

### Review with custom instructions

`[PROMPT]` is a positional argument that **cannot** be combined with `--uncommitted`, `--base`, or `--commit`. Use it alone for a free-form review prompt:

```bash
codex exec review "Focus on error handling and edge cases"
```

## Workflow

1. **Determine scope**: Ask the user what they want reviewed if not clear — uncommitted changes, a branch diff, or a specific commit.
2. **Run the review**: Execute `codex exec review` with the appropriate flags.
3. **Present findings**: Share the review output with the user. Highlight critical issues separately from suggestions.
4. **Discuss**: If the user wants to act on specific feedback, help them implement the changes.

## Important Guidelines

- Default to `--uncommitted` when the user says "review my changes" without further detail
- Use `--base main` when reviewing a feature branch's full diff
- The review runs non-interactively and returns structured feedback
- Treat the review as advisory — not all suggestions need to be applied

## Help

!`codex exec review --help`

## Available Models

!`jq -r '.models[] | "- \(.slug): \(.description)"' "$CODEX_HOME/models_cache.json"`

Pick a `--model` slug from the list above. Prefer Spark models for speed. Use the latest non-Spark model for deeper analysis.
