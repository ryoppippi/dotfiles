---
name: fix-ci
description: When GitHub Actions checks are failing on the current branch or PR.
---

<!--
Example prompts:
  /fix-ci
-->

**Current branch:** `!`git branch --show-current``

**PR check status:**

```
!`gh pr checks`
```

1. Establish whether a PR exists with `gh pr view`; distinguish an absent PR
   from authentication or network errors. For a confirmed absent PR, inspect
   `gh run list --branch <current-branch>`. A non-zero `gh pr checks` status
   can mean failing or pending checks, not a missing PR. Stop only after
   confirming there are no failures.
2. Read the failing logs: `gh run view <run-id> --log-failed`.
3. Find why it fails — the code, the workflow, or the environment — before
   changing anything. Check whether other jobs or workflows share the cause.
4. Fix the cause. Re-running, skipping, loosening a check, or adding a retry is
   a fix only when the failure really is external flakiness; say so when it is.
