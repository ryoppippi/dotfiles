---
name: codex-review
description: Run a code review using Codex or a native subagent. Use when the user wants a code review of uncommitted changes, a specific commit, or changes against a base branch.
---

Use the review path that matches the current session:

- Inside T3 Code (the `t3-code` MCP `delegate_task` tool is available): delegate the review as a T3 child task; see [T3 Code](#t3-code).
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

## T3 Code

T3 has no `codex exec review` equivalent for agents, so brief a child task:

- Pick the `codex` provider instance and a model from `orchestrator_capabilities` (its live catalog replaces the list below), and pass `target.model` explicitly.
- Call `delegate_task` with `role: "review"`, `interactionMode: "plan"`, and `mode: "async"`. Leave `runtimeMode` unset so the child never waits on an approval this thread cannot give.
- Name the scope as the git command from [Scope](#scope) for the reviewer to run, tell it not to edit files, and ask for critical findings separately from suggestions with `file:line` references.
- Keep the default shared checkout: `isolation: "worktree"` starts from the last commit and drops uncommitted changes.
- End the turn and wait for the completion notification. For a re-review, call `delegate_task` again with the original brief, the prior findings, and what changed, under a new `clientRequestId`.

## Available Models

!`jq -r '.models[] | "- \(.slug): \(.description)"' "$CODEX_HOME/models_cache.json"`

Choose a Spark model for speed or the latest non-Spark model for deeper analysis.
