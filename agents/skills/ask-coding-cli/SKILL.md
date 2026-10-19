---
name: ask-coding-cli
description: Gets an independent second opinion from another coding agent CLI — Codex, Claude Code, Grok, or Cursor — or hands one a task the user names it for. Use when the user asks for one of them, or before a significant approach is settled — not for routine searches, which go to the current agent's own subagents.
---

<!--
Example prompts:
  /ask-coding-cli Review my implementation plan
  /ask-coding-cli Ask codex whether this error handling is right
  /ask-coding-cli Get claude's take on this migration
-->

# Ask a Coding CLI

Use the agent the user names. Otherwise pick one that is not the agent you are
running in — Codex from Claude Code, Claude Code from Codex — since a second
opinion from the same model adds little.

Inside T3 Code, read [references/inside-t3.md](references/inside-t3.md);
otherwise read [references/outside-t3.md](references/outside-t3.md).

Every path takes a self-contained prompt: the other agent sees none of this
conversation, so whatever it cannot infer has to be in the prompt. Keep it
focused — the relevant files, the decision at stake, and the constraints —
rather than dumping the whole codebase.

## Models

- Codex: the latest `luna` — a small model gains most from the lower latency.
  `scripts/codex-model.nu` in this skill's directory resolves the newest slug of
  a family (default `luna`) from Codex's live catalog, so no model name is
  pinned here.
- Claude Code: the `fable` alias, which maps to the newest model of that tier.
  Pass an alias, never a full model ID.
- Grok: its default, which is already its latest model.
- Cursor: `auto`, its default, which routes to its current models.

## Briefing and using the answer

- Say which facts to return, and demand a citation for each — a URL, or a
  `file:line`.
- Ask for verbatim quotes wherever exact spelling matters: API options, flags,
  version numbers. A digest paraphrases them away.
- For a second opinion, ask for an independent assessment rather than agreement
  with your plan.

Treat the reply as one data point: compare it against your own reading of the
codebase, report both views to the user with the disagreements intact, and
prefer established project patterns where they conflict. Let the user make the
final call.
