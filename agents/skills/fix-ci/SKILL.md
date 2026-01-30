---
name: fix-ci
description: Automatically diagnose and fix CI failures using the gh CLI. Fetches logs from broken GitHub Actions, analyses errors, and applies fixes.
---

<!--
Example prompts:
  /fix-ci
-->

Let's fix whatever error we can find in CI using the `gh` CLI.

## Steps

- Figure out which PR we have for the current branch
- Figure out which action is broken
- If nothing is broken, bail.
- Fetch the logs for the action
- Make a quick plan on what needs to be fixed
- Fix the error
