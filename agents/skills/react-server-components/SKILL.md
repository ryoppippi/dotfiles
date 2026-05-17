---
name: react-server-components
description: Reviews React Server/Client Component boundaries against Next.js and React docs. Use when auditing `'use client'` placement or splitting components for proper RSC behaviour.
---

<!--
Example prompts:
  /react-server-components
  /react-server-components scope=src/app/
  /react-server-components fix=false
-->

Arguments:

- scope: what to analyse (default: your current changes). Examples: "diff to main", "PR #123", "src/app/", "whole codebase"
- fix: whether to apply fixes (default: true). Set to false to only propose changes.

Steps:

1. Read https://react.dev/reference/rsc/server-components and https://nextjs.org/docs/app/building-your-application/rendering/composition-patterns to understand the guidelines
2. Analyse the specified scope for Server/Client Component anti-patterns
3. If fix=true, apply the fixes. If fix=false, propose the fixes without applying.
