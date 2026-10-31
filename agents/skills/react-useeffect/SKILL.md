---
name: react-useeffect
description: When writing or reviewing React code that uses or adds `useEffect`.
---

<!--
Example prompts:
  /react-useeffect scope=diff to main
  /react-useeffect fix=false
-->

Arguments: `scope` (default: current changes; e.g. "diff to main", "PR #123",
"src/components/") and `fix` (default `true`; `false` only proposes changes).

1. Read https://react.dev/learn/you-might-not-need-an-effect
2. Review the scope for effects that derive state, respond to events, chain
   updates, or sync with the parent, and replace them with what the guide
   recommends.
3. Apply the fixes, or propose them when `fix=false`.

`useEffect` is an escape hatch for synchronising with external systems. Keep one
when synchronisation is needed. Comment only when its reason is non-obvious
and a future reader might otherwise remove it.
