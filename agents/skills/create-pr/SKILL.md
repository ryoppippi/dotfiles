---
name: create-pr
description: Runs the full PR workflow — creates a feature branch, commits, pushes, and opens the pull request. Use when the user asks to create or open a PR ("create a PR", "push this up and open a PR").
---

# Create PR

Use this skill when the user asks to create or open a pull request.

## Workflow

1. Inspect the current branch, status, and diff:

   ```sh
   git status --short
   git branch --show-current
   git diff --stat
   ```

2. If the current branch is `main`, create a feature branch with a `feature/`, `fix/`, or `chore/` prefix unless the user requested a different branch name.

3. Review the diff before committing. Exclude unrelated changes, temporary files, secrets, generated junk, and debug-only edits.

4. Commit with the repo-local `commit` skill using an English Conventional Commit message. When CI is unnecessary for the change, append `[ci skip]` to the commit message.

5. Prepare a PR title and body proportional to the change:

   - Use a Conventional Commit type such as `feat`, `fix`, `docs`, `refactor`, or `chore` in the PR title.
   - For a small focused change, use 2–4 sentences covering what changed and why.
   - For a larger change, include Summary, What Changed, Why, and Testing only when tests were actually run. Add Related Issues only when relevant.
   - Use `--body-file -` for multi-line bodies. Do not embed `\n` escape sequences in `--body`.

6. Publish using the first available path:

   - If the `gh-stack` extension is installed, inspect the current stack with `gh stack view --json` and follow the `gh-stack` skill. Initialise or adopt the current branch as a stack when needed, push with `gh stack push`, and create the PR with `gh stack submit --auto --open`. Follow all of its non-interactive command rules.
   - Otherwise, push the branch and create the PR with:

     ```sh
     git push -u origin <branch-name>
     gh pr create --title "feat(scope): summary" --body-file -
     ```

7. Report the PR URL. If publishing fails, inspect the error and verify the branch, remote, authentication, or duplicate PR state before retrying.

All commit messages, PR titles, and PR bodies must be in English. Confirm the target branch before creating the PR, and do not call it ready until the relevant checks and review feedback have been inspected.
