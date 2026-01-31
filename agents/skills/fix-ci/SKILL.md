---
name: fix-ci
description: Automatically diagnose and fix CI failures using the gh CLI. Fetches logs from broken GitHub Actions, analyses errors, and applies fixes.
---

<!--
Example prompts:
  /fix-ci
-->

Let's fix whatever error we can find in CI using the `gh` CLI.

**Current branch:** `!`git branch --show-current``

**PR check status:**
```
!`gh pr checks 2>/dev/null || echo "No PR found for current branch"`
```

## Steps

1. **Analyse the check status above**: Identify which actions are failing
2. If nothing is broken, bail.
3. Fetch the logs for the broken action using `gh run view <run-id> --log-failed`
4. Make a quick plan on what needs to be fixed
5. Fix the error
