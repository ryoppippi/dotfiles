---
name: merge-main
description: When syncing the current branch with the latest main.
---

**Current branch:** `!`git branch --show-current``
**Upstream:** `!`git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "No upstream configured"``
**Behind/ahead of origin/main:** `!`git rev-list --left-right --count origin/main...HEAD 2>/dev/null || echo "Unable to compare"``

1. If on `main`, switch to the feature branch first.
2. Fetch the remote that owns `main` — `origin`, or `upstream` for a fork — and
   merge its `main` (`git merge origin/main` or `git merge upstream/main`).
3. Resolve conflicts by understanding what each side intended, not by picking a
   side per hunk; explain each resolution.
4. Stage resolved paths and complete a conflicted merge with `git merge --continue`.
   Run the relevant checks, then push the branch.
