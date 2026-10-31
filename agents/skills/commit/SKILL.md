---
name: commit
description: When committing changes, committing and pushing without a PR, or writing a commit message.
---

<!--
Example prompts:
  /commit
  /commit push=true
-->

# Commit

Make small Conventional Commits that can each be reverted on their own.

Argument `push` (default `false`): push once all commits are made. Use it for
"commit and push" requests.

## Workflow

1. Read `git status --short`, `git diff HEAD`, and `git log --oneline -10`.
2. Split the changes into the smallest units that each make sense and revert
   cleanly. A move or extraction keeps both sides and the updated references in
   one commit; unrelated changes stay out.
3. Stage each unit non-interactively: `git add <path>` for whole files,
   `git apply --cached` with a patch for parts of a file. Never `git add -p`.
   The index may already hold changes staged for `nix run .#switch`; check
   the full staged diff before each commit and unstage anything outside the
   current commit unit.
4. Write the message in English with UK spelling:

   ```text
   <type>(<scope>): <subject>

   <body: the cause, and why this change>
   ```

   Use a standard type (`feat`, `fix`, `docs`, `refactor`, `chore`, `test`,
   `ci`, `build`, `perf`, `revert`). Append `[ci skip]` only when CI is
   unnecessary and the repository allows skipping it.

5. Commit, then check `git show HEAD` and `git diff --check`.

Fixes for published review comments go in follow-up commits; amend only
unpublished local mistakes or when asked.

## Push

Only when `push=true`, follow the repository's branch rules. On `main`/`master`, create a feature
branch first unless the repository allows pushing there. Push with `git push`;
if the branch has no upstream, ask before `git push -u origin HEAD`. Report the
branch and the pushed commits.
