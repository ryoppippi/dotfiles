---
name: review
description: Reviews uncommitted changes, a commit, or a branch with another vendor's model or harness — Codex from Claude Code, Claude Code from Codex. Use when the user asks for a code review, or before opening a PR.
---

# Review

A review from the model and harness that wrote the change catches little, so send it to another vendor's model, another vendor's harness, or both.

Inside T3 Code, read [references/inside-t3.md](references/inside-t3.md); otherwise read [references/outside-t3.md](references/outside-t3.md).

## Models

ryoppippi's current picks, best first. They reflect ryoppippi's judgement of quality, not the vendors' tier order: follow them over any assumption about which model is the newest or the flagship, and edit this list when the judgement changes. Each is a family or alias that resolves to the newest version, so never pin a version number.

- Codex: `astra`, then `sol`
- Claude: `opus`; `fable` only for a genuinely hard review

## Scope

- Uncommitted changes: `--uncommitted`, or `git diff HEAD` plus untracked files.
- A branch: `--base <branch>`, or `git diff <branch>...HEAD`.
- A commit: `--commit <sha>`, or `git show <sha>`.

Ask when the requested scope is unclear. Every reviewer except `codex exec review` takes the scope as its git command inside a brief like this:

```text
Review the changes in `git diff main...HEAD` for correctness bugs. Do not edit files. Cite file:line for every finding, and list critical findings separately from suggestions.
```

## Reporting

Verify each finding against the code before acting on it. Report critical findings separately from suggestions, with file and line references, and say which harness and model reviewed.
