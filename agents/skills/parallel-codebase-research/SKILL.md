---
name: parallel-codebase-research
description: When the user asks for many parallel agents to explore an unfamiliar area of a codebase before a plan or design decision.
---

<!--
Example prompts:
  /parallel-codebase-research area=authentication
  /parallel-codebase-research n=5
-->

1. Survey the area yourself first: key terms, entry points, and the overall
   architecture.
2. Spawn `n` subagents (default 10) with distinct angles on the area, including a
   few deliberately unconventional ones for variance. Give each a self-contained
   brief and ask for conclusions with `file:line` evidence.
3. Reconcile their findings, keeping disagreements visible, and use them for
   what the user asked — in plan mode, the plan.
