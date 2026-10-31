---
name: ask-other-agent
description: When the user asks Codex, Claude Code, Grok, or Cursor for an opinion or a task, or before settling a significant approach.
---

<!--
Example prompts:
  /ask-other-agent Review my implementation plan
  /ask-other-agent Ask codex whether this error handling is right
-->

# Ask Another Agent

Use the agent the user names; for the current harness, use its native
subagent instead of a nested CLI. Otherwise pick one that is not the agent you are
running in — Codex from Claude Code, Claude Code from Codex — since a second
opinion from the same model adds little. Routine searches go to your own
subagents instead.

Inside T3 Code, read [references/inside-t3.md](references/inside-t3.md);
otherwise read [references/outside-t3.md](references/outside-t3.md).

## Models

Never pin a version; each choice below resolves to the newest.

- Codex: the latest `luna`. Run `scripts/codex-model.nu [family]` to resolve the
  newest slug of a family from Codex's live catalogue.
- Claude Code: the `fable` alias.
- Grok: its default.
- Cursor: `auto`, its default.

## Briefing and using the answer

The other agent sees none of this conversation. Give it the relevant files, the
decision at stake, and the constraints, and ask for an independent assessment
rather than agreement, with a citation (URL or `file:line`) for each fact and
verbatim quotes where exact spelling matters.

Treat the reply as one data point: check it against the code, report both views
to the user with disagreements intact, and let the user decide.
