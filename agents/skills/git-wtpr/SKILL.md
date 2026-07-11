---
name: git-wtpr
description: Opens a GitHub pull request in a git-wt worktree from a PR number or URL. Use when creating or switching to a worktree for a specific PR.
---

# Git Worktrees for Pull Requests (git-wtpr)

Use `git wtpr` to create or switch to a worktree checked out at a PR head.
Builds on `git-wt` — prefer this over `gh pr checkout` when isolation in a
worktree is needed.

## Usage

```sh
git wtpr <number|url> [git-wt flags...]
```

Examples:

```sh
git wtpr 25
git wtpr https://github.com/owner/repo/pull/3984
```

Interactive use (with `git-wtpr --init fish`) **cds into the worktree**,
same as `git wt`. Do not pass `--nocd` unless you only need the path.

Confirm availability with `command -v git-wtpr` or `git-wtpr --help`.

## Behaviour

1. Resolves the PR with `gh pr view` (number or URL).
2. Ensures the current clone matches the PR repository.
3. Fetches `pull/<n>/head` from the remote.
4. Creates or switches a worktree via `git wt` on the PR head branch name.
5. If the head branch is `main`/`master`, uses `pr-<number>` instead.
6. Shell integration cds into that worktree (unless `--nocd` / `wt.nocd`).

Status goes to stderr. The worktree path is the last stdout line.

## Workflow for agents

1. Run from the correct repository clone (not a random directory).
2. Use `git wtpr --nocd <pr>` — shell `cd` does not persist across tool
   calls, so capture the printed path and use it as the working directory.
3. Verify inside the worktree: `git branch --show-current` and
   `git status --short`.
4. For general worktree lifecycle (list, delete, rename), use the `git-wt`
   skill — `git wtpr` only opens PR worktrees.

## Related

- `git-wt` skill for worktree create/switch/delete/rename
- `agents/shared/git-worktrees.md` for when not to create a new worktree
