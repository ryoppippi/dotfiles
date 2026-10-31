---
name: git-worktrees
description: When creating, switching, listing, renaming, or deleting git worktrees, or checking out a pull request in a worktree.
---

# Git Worktrees

Use `git wt` (and `git wtpr` for pull requests) rather than raw
`git worktree add`/`remove`/`move`/`prune` or `gh pr checkout`.

## Are you already in one?

```sh
git rev-parse --path-format=absolute --git-dir
git rev-parse --path-format=absolute --git-common-dir
```

Different paths mean the current directory is already a linked worktree: stay
in it unless the user asks for another. Equal paths mean the main worktree;
create a linked one only when the task needs isolation.

## Working in a worktree

Shell `cd` does not persist between tool calls, so always pass `--nocd`, take
the printed path (the last stdout line), and use it as the working directory.
Check `git branch --show-current` and `git status --short` there before editing.

- Branch: `git wt --nocd <branch> [<start-point>]`; list with
  `git wt --json | jq`.
- Pull request: `git wtpr --nocd <number|url>`, run from a clone of the PR's
  repository.

## Deleting and renaming

Check `git status --short` in the target worktree first.

- Delete: `git wt -d <branch>` or `git wtpr <pr> -d`. Force (`-D`) only when the
  user asks or safe deletion fails and discarding the work is confirmed.
- Rename: `git wt -m [<old>] <new>`; `-M` only when overwriting is explicitly
  wanted.

`git wt --help` and `git wtpr --help` cover the rest.
