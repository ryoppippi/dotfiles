---
name: commit
description: Creates atomic Conventional Commits. Use when committing code changes, splitting hunks into revertable units, or writing commit messages.
---

<!--
Example prompts:
  /commit
  /commit push=true
-->

# Commit

Create small, independently revertable Conventional Commits.

## Arguments

- `push`: whether to push after committing (default: `false`). Set to `true` to push.

## Workflow

1. Inspect the current state:

   ```sh
   git status --short
   git diff HEAD
   git log --oneline -10
   ```

2. Review relevant history and split the changes into the smallest independently revertable units. Keep unrelated changes out of the commit. For moves or extractions, include both sides and update references.

3. Stage each unit non-interactively with `git apply --cached -v`. Read `references/git-apply.md` when precise staging needs troubleshooting.

   Never stage with `git add -A`, `git add --all`, `git add .`, or `git add -u` — they sweep unrelated working-tree changes into the commit. When a whole file belongs to the unit, name it: `git add <path>`. Never use `git add -p` or any other interactive staging. `git commit -a`/`-am` carries the same hazard — commit from the index only.

   The index may already hold changes staged for an earlier build (`nix run .#switch` needs staged files). Treat a pre-populated index as untrusted: check `git diff --cached --stat` and unstage anything outside the current unit with `git restore --staged <path>` before committing.

4. Write an English Conventional Commit message using UK spelling:

   ```text
   <type>(<scope>): <subject>

   <body>
   ```

   Use a standard type such as `feat`, `fix`, `docs`, `refactor`, `chore`, `test`, `ci`, `build`, `perf`, or `revert`. Keep the body concise and explain what changed and why when the subject is not sufficient. When CI is unnecessary and repository instructions permit skipping it, append `[ci skip]` to the commit message.

5. Commit and verify with `git show HEAD` and `git diff --check`.

Keep published review fixes as separate follow-up commits; amend only unpublished local mistakes or when explicitly requested. Read `references/revertable-commits.md` for detailed examples.

## Push

When `push=true`, push after all commits are complete and let repository hooks run. Read `references/push.md` for the exact push procedure.
