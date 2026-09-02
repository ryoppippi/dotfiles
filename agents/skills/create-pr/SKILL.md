---
name: create-pr
description: Runs the full PR workflow — creates a feature branch, commits, pushes, and opens the pull request. Use when the user asks to create or open a PR ("create a PR", "push this up and open a PR").
---

# Create PR

Use this skill when the user asks to create or open a pull request.

## PR Granularity

A PR is a reviewable responsibility unit; one PR may contain multiple atomic commits. A branch is not a PR boundary: split independent work into separate PRs and stack only dependent work.

## Workflow

1. Inspect the current branch, status, and diff:

   ```sh
   git status --short
   git branch --show-current
   git diff --stat
   ```

2. If the current branch is `main`, create a feature branch with a `feature/`, `fix/`, or `chore/` prefix unless the user requested a different branch name.

3. Review the diff before committing. Exclude unrelated changes, temporary files, secrets, generated junk, and debug-only edits.

4. Commit with the repo-local `commit` skill using an English Conventional Commit message. When CI is unnecessary and repository instructions permit skipping it, append `[ci skip]` to the commit message.

5. Prepare a PR title and body proportional to the change:

   - Use a Conventional Commit type such as `feat`, `fix`, `docs`, `refactor`, or `chore` in the PR title.
   - For a small focused change, use 2–4 sentences covering what changed and why.
   - For a larger change, include Summary, What Changed, Why, and Testing only when tests were actually run. Add Related Issues only when relevant.
   - Use `--body-file -` for multi-line bodies. Do not embed `\n` escape sequences in `--body`.

6. When the change is visual (UI, layout, rendering, or a bug that is clearer on screen), attach local screenshots or short videos to the PR with `gh pr create --attach` (`gh` ≥ 2.99.0). Prefer real artifacts already produced while implementing or testing — do not invent media, and skip attach when there is nothing useful to show. If `gh pr create --help` does not list `--attach`, skip media upload and open the PR with text only (nixpkgs will pick up a new enough `gh` in time).

   - Put Markdown image/video references in the body using local paths (e.g. `![Login after fix](./after.png)`). `gh` rewrites those paths to uploaded URLs in place and keeps the alt text.
   - Pass each file with `--attach` (repeatable). Optional alt text after `#` when the body does not already reference the path: `--attach './after.png#Login after fix'`.
   - Supported types include PNG, JPEG, GIF, WebP, SVG, MP4, MOV, and WebM. Size limits match the web upload flow.
   - If media appears only after the PR exists (e.g. a walkthrough recorded while verifying), attach it with `gh pr edit --attach` or `gh pr comment --attach` instead of recreating the PR.
   - See `gh pr create --help` for flag syntax. Overview: https://gh.io/gh-attach

7. Publish using the path that matches the PR structure:

   - Use `gh-stack` only when requested or when the branch is already stacked; verify parent-child ancestry before linking.
   - For an ordinary PR, push the branch and create the PR with:

     ```sh
     git push -u origin <branch-name>
     gh pr create --title "feat(scope): summary" --body-file -
     ```

     When step 6 produced media, add one `--attach <path>` (or `--attach 'path#alt'`) per file on that `gh pr create` invocation.

8. Report the PR URL. If publishing fails, inspect the error and verify the branch, remote, authentication, `gh` version, or duplicate PR state before retrying.

All commit messages, PR titles, and PR bodies must be in English. Confirm the target branch before creating the PR, and do not call it ready until the relevant checks and review feedback have been inspected.
