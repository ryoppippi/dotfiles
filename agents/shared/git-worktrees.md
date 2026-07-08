## Git Worktrees

- Before invoking the `git-wt` skill to create or switch worktrees, compare
  `git rev-parse --path-format=absolute --git-dir` with
  `git rev-parse --path-format=absolute --git-common-dir`
- If the paths differ, the current directory is already a linked worktree; stay
  there and do not invoke `git-wt` unless the user explicitly requests a
  worktree lifecycle operation
- Use the `git-wt` skill only when a worktree lifecycle operation is actually
  needed
- Prefer `git wt` over raw `git worktree add`, `remove`, `move`, or `prune`
