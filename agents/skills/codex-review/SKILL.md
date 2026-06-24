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

You are a code review coordinator. When invoked, run a code review using Codex.

## First: which agent are you?

This skill is shared between agents (Claude Code, Codex, etc.). Pick the path that matches the session you are running in:

- **You are NOT Codex** (e.g. Claude Code) → use the [Codex CLI path](#codex-cli-path-default). Shelling out to `codex exec review` gives you an independent second opinion from a different agent.
- **You ARE Codex** (this is a Codex CLI session) → use the [Subagent path](#subagent-path-running-inside-codex). Spawning `codex exec review` from inside Codex starts a whole new Codex process (cold start, fresh model load, duplicated context) just to call the same engine you are already running. The overhead is large and pointless — delegate to a subagent instead.

## Codex CLI path (default)

Use `codex exec review` with the appropriate flags.

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

## Subagent path (running inside Codex)

Do **not** run `codex exec review` here. Instead, launch a subagent (Codex multi-agent is enabled) and have it perform the review in-process:

1. **Determine scope** exactly as below.
2. **Delegate to a subagent** with a self-contained prompt describing the scope and what to inspect. The subagent does not share your conversation, so spell out which diff to review, e.g.:
   - Uncommitted: review the output of `git diff HEAD` plus untracked files.
   - Base branch: review the output of `git diff main...HEAD`.
   - Specific commit: review the output of `git show <SHA>`.
3. **Ask the subagent for structured findings**: critical issues separated from suggestions, each with file/line references.
4. **Collect and present** the subagent's findings to the user.

## Workflow

1. **Determine scope**: Ask the user what they want reviewed if not clear — uncommitted changes, a branch diff, or a specific commit.
2. **Run the review**: Use the Codex CLI path or the Subagent path depending on which agent you are.
3. **Present findings**: Share the review output with the user. Highlight critical issues separately from suggestions.
4. **Discuss**: If the user wants to act on specific feedback, help them implement the changes.

## Important Guidelines

- Default to `--uncommitted` (or the equivalent `git diff HEAD` scope for the subagent path) when the user says "review my changes" without further detail
- Use `--base main` (or `git diff main...HEAD`) when reviewing a feature branch's full diff
- The review runs non-interactively and returns structured feedback
- Treat the review as advisory — not all suggestions need to be applied

## Help

!`codex exec review --help`

## Available Models

!`jq -r '.models[] | "- \(.slug): \(.description)"' "$CODEX_HOME/models_cache.json"`

Pick a `--model` slug from the list above. Prefer Spark models for speed. Use the latest non-Spark model for deeper analysis.
