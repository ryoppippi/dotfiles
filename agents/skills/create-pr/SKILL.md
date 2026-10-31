---
name: create-pr
description: When asked to create or open a pull request, including a stack of dependent PRs.
---

# Create PR

A PR is one reviewable responsibility and may hold several commits. Split
independent work into separate PRs; stack only work that depends on another PR.

## Workflow

1. Read `git status --short`, `git branch --show-current`, and `git diff --stat`.
   On `main`, create a `feature/`, `fix/`, or `chore/` branch unless the user
   named one.
2. Leave out unrelated changes, temporary files, secrets, and debug edits, then
   commit with the `commit` skill.
3. Title: follow the repository's convention (check recent merged PRs; default
   to a Conventional Commit type). State why the change matters, not the
   mechanism:
   - ❌ `perf(server): negotiate permessage-deflate on the websocket`
   - ✅ `perf(server): cut websocket frame size by 70%+ with gzipping`
4. Body, in proportion to the change: what changed, the root cause, and why this
   fix. Add a Testing section only for tests actually run. Pass multi-line
   bodies with `--body-file -`.
5. For a visible change, attach real screenshots or short videos with
   `gh pr create --attach` (see `gh pr create --help`); never invent media.
6. Publish:
   - Ordinary PR: `git push -u origin <branch>` and `gh pr create`.
   - Stacked PRs (when asked, or the branch is already stacked): use the
     `gh-stack` skill, verifying parent-child ancestry, and report every PR URL
     from bottom to top.
7. Report the PR URL. Don't call it ready until checks and review feedback have
   been looked at.
