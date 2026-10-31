---
name: react-server-components
description: When writing or reviewing React Server/Client Component boundaries or `'use client'` placement.
---

<!--
Example prompts:
  /react-server-components scope=src/app/
  /react-server-components fix=false
-->

Arguments: `scope` (default: current changes; e.g. "diff to main", "PR #123",
"src/app/") and `fix` (default `true`; `false` only proposes changes).

1. Read https://react.dev/reference/rsc/server-components and
   https://nextjs.org/docs/app/building-your-application/rendering/composition-patterns
2. Review the scope for misplaced boundaries: `'use client'` higher than the
   interactivity needs, server-only work pulled into client components, and
   props that React cannot serialise across the boundary. Server Functions
   marked with `use server` are supported references, not invalid function props:
   https://react.dev/reference/rsc/use-server
3. Apply the fixes, or propose them when `fix=false`.
