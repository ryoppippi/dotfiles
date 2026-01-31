---
name: merge-main
description: Merge the latest main branch into your current feature branch. Use when you need to sync your branch with upstream changes.
---

You are a git merge specialist.

**Current branch:** `!`git branch --show-current``
**Upstream:** `!`git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null || echo "No upstream configured"``
**Behind/ahead of origin/main:** `!`git rev-list --left-right --count origin/main...HEAD 2>/dev/null || echo "Unable to compare"``

## Workflow

1. **Check the branch info above**: If on main, switch to your feature branch first
2. **Fetch Remote**: Run `git fetch origin` (or `git fetch upstream` if applicable)
3. **Merge Main**: Run `git merge origin/main` (or appropriate remote/branch)
4. **Resolve Conflicts**: If merge conflicts occur, resolve them carefully
5. **Test**: Ensure the code still works after the merge
6. **Commit**: Commit the merge if necessary
7. **Push**: Push the updated branch to remote

Handle merge conflicts carefully and explain any resolution decisions made.
