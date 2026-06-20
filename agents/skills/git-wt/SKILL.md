---
name: git-wt
description: Manages worktree lifecycle operations through git-wt without replacing an existing linked worktree. Use when creating, switching, listing, renaming, or deleting worktrees.
---

# Git Worktrees with git-wt

Use `git wt` for worktree lifecycle operations. Do not use raw
`git worktree add`, `remove`, `move`, or `prune` when `git-wt` can perform the
operation.

## Current Worktree Detection

Before creating or switching worktrees, compare these paths:

```sh
git rev-parse --path-format=absolute --git-dir
git rev-parse --path-format=absolute --git-common-dir
```

Different paths mean the current directory is already inside a linked
worktree. Continue in that worktree unless the user explicitly requests a
different one. Do not create or select another worktree merely to satisfy an
isolation convention.

Equal paths mean the current directory is the main worktree. Create or select
a linked worktree only when the task or user actually requires isolation.

## Workflow

1. Detect whether the current directory is already a linked worktree.
2. If a lifecycle operation is needed, confirm the command is available with
   `git-wt --version`.
3. Inspect existing worktrees with `git wt --json | jq`.
4. Create or select a worktree with `git wt --nocd <branch-or-worktree>`.
   Add a start point when needed:
   `git wt --nocd <branch-or-worktree> <start-point>`.
5. Treat the printed path as the worktree root and use it as the working
   directory for subsequent commands. Do not rely on shell directory changes
   persisting between tool calls.
6. Verify the branch and status inside the selected worktree before editing:
   `git branch --show-current` and `git status --short`.

Use `git wt -b <branch> --nocd <worktree>` when the worktree directory and
branch names should differ.

## Destructive Operations

- Delete safely with `git wt -d <branch-or-worktree>`.
- Use `git wt -D <branch-or-worktree>` only when the user explicitly requests
  forced deletion or safe deletion fails and discarding the work is confirmed.
- Rename safely with `git wt -m [<old>] <new>`.
- Use `git wt -M [<old>] <new>` only when overwrite or force behaviour is
  explicitly required.
- Inspect `git status --short` in the target worktree before deleting or
  force-renaming it.

Run `git-wt --help` for flags and configured behaviour when the requested
operation is not covered above.
