---
name: address-pr-review
description: When addressing review comments on the current pull request.
---

**PR:**

```
!`gh pr view 2>/dev/null || echo "No PR found for current branch"`
```

**Conversation comments and reviews:**

```
!`gh pr view --comments 2>/dev/null || echo "No comments found"`
```

Inline review comments are not in the output above; fetch them with
`gh api repos/{owner}/{repo}/pulls/<number>/comments`.

For each comment:

1. Work out what the reviewer is actually worried about and whether you agree.
2. Fix the cause it points at, and look for the same problem elsewhere in the
   change rather than patching only the quoted line.
3. Push fixes as normal follow-up commits with the `commit` skill.

Report each comment with what you changed, or why you disagree.
