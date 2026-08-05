## Git Staging

- Stage explicit paths only: `git add <path> [<path> …]`
- Never use `git add -A`, `git add --all`, `git add .`, or `git add -u`. They
  sweep in every unrelated working-tree change, including files that must not be
  committed casually — for example `nix/modules/home/programs/codex.nix`, which
  can contain private repository names. `git commit -a`/`-am` bypasses the index
  the same way — commit from the index only
- Run `git status --short` before staging, and derive the path list from
  `git diff --name-only` plus the untracked files you actually created. A long
  path list is correct; a catch-all flag is not
- Staging for a build is not staging for a commit. Nix flakes only see tracked,
  staged files, so `git add` is required before `nix run .#switch` — that
  staging is a build prerequisite, not a commit plan
- Before committing, re-read the index with `git diff --cached --stat` and
  unstage anything the task did not touch
