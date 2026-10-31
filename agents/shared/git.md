## Git

- Stage explicit paths and commit from the index. Never `git add -A` / `.` / `--all` / `-u` or `git commit -a`: the working tree can hold local or private changes that must not be committed.
- Local changes to `nix/modules/home/programs/codex/default.nix` may contain private repository names; review them before staging or publishing.
- Staging for `nix run .#switch` (flakes only see tracked files) is not staging for a commit. Before committing, check `git diff --cached --stat` and unstage whatever the task did not touch.
- If the current directory is already a linked worktree, stay in it. For worktree lifecycle and PR checkouts, use the `git-worktrees` skill rather than raw `git worktree` or `gh pr checkout`.
