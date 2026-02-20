---
name: you-might-not-need-an-effect
description: Review React code for unnecessary useEffect usage based on react.dev guidelines. Analyses code for useEffect anti-patterns and optionally applies fixes. Use when reviewing React code quality or refactoring effects.
---

<!--
Example prompts:
  /you-might-not-need-an-effect
  /you-might-not-need-an-effect scope=diff to main
  /you-might-not-need-an-effect fix=false
-->

Arguments:

- scope: what to analyze (default: your current changes). Examples: "diff to main", "PR #123", "src/components/", "whole codebase"
- fix: whether to apply fixes (default: true). Set to false to only propose changes.

Steps:

1. Read https://markdown.new/https://react.dev/learn/you-might-not-need-an-effect to understand the guidelines
   1.1 if you cannot access the link, go directly to https://react.dev/learn/you-might-not-need-an-effect and read the content there.
2. Analyze the specified scope for useEffect anti-patterns
3. If fix=true, apply the fixes. If fix=false, propose the fixes without applying.
4. If you REALLY REALLY need to use useEffect, add a comment in the code explaining why it's necessary and link to the relevant section of the guidelines.
5. Remember, useEffect is a escape hatch. If you cannot find alternative solutions, it's a kind of your loser's choice. But always try to find alternatives first before resorting to useEffect.
