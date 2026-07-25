---
name: git-wtpr
description: Opens or deletes a git-wt worktree for a GitHub pull request. Use when creating, switching to, or removing a PR worktree.
---

# Git Worktrees for Pull Requests (git-wtpr)

Use `git wtpr` to create or switch to a worktree checked out at a PR head.
Builds on `git-wt` — prefer this over `gh pr checkout` when isolation in a
worktree is needed.

## Usage

```sh
git wtpr <number|url> [git-wt flags...]
git wtpr <number|url> -d | -D
```

Examples:

```sh
git wtpr 25
git wtpr https://github.com/owner/repo/pull/3984
git wtpr 25 -D                                    # remove that PR worktree
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

With `-d` (safe) or `-D` (force) the PR worktree and its branch are
deleted instead — the PR is still resolved to get the branch name, but
step 3 is skipped.

## Workflow for agents

1. Run from the correct repository clone (not a random directory).
2. Use `git wtpr --nocd <pr>` — shell `cd` does not persist across tool
   calls, so capture the printed path and use it as the working directory.
3. Verify inside the worktree: `git branch --show-current` and
   `git status --short`.
4. To clean up afterwards, run `git wtpr <pr> -D` from the same clone (or
   `git wt -D <branch>`). For other lifecycle operations (list, rename),
   use the `git-wt` skill.

## Related

- `git-wt` skill for worktree create/switch/delete/rename
- `agents/shared/git-worktrees.md` for when not to create a new worktree
