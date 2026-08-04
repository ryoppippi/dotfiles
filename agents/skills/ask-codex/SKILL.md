---
name: ask-codex
description: Runs Codex CLI for a second opinion on a decision, or as a cheap subagent for bulky work. Use before a significant approach is settled, or instead of reading pages and long output here.
---

<!--
Example prompts:
  /ask-codex Review my implementation plan
  /ask-codex Is this the right approach for error handling?
-->

# Ask Codex

Two jobs, two commands. Both take a self-contained prompt: Codex sees none of this
conversation, so whatever it cannot infer has to be in the prompt.

## Second opinion

```sh
codex exec "<question>"
```

Leave the model alone — the reasoning effort in Codex's own config is what makes
the answer worth having. Treat the reply as one data point: compare it against your
own reading of the codebase, report both views to the user with the disagreements
intact, and prefer established project patterns where they conflict.

## Delegated grunt work

```sh
codex exec --skip-git-repo-check --ephemeral -m gpt-5.6-luna "<task>"
```

For work whose output is bulky but whose conclusion is small: web search, page
reading, codebase investigation, summarising long output, drafting a commit message
from a diff. A cheap model is the point — the subscription pays for it and only the
answer costs tokens here. `codex exec --help` carries the rest; reach for `-o` to
capture the final message alone, and `--sandbox`/`--add-dir` to widen what it may
touch.

Measured, and not visible in the help output:

- Keep `model_reasoning_effort` at `medium` or above. At `low` it answered a
  "latest release version" search from stale knowledge.
- Never `--disable multi_agent`. Native web search runs through it, so disabling it
  makes a search task hang indefinitely with no tool call.
- Shell commands only reach the network under `--sandbox workspace-write` with
  `-c sandbox_workspace_write.network_access=true`. The native web search needs
  neither.
- `exa` cannot run there at all: no sandbox mode reaches its 1Password key, so run
  exa in this session. `ax` and `tgrab` live in `~/.agents/skills/web-fetch/` —
  prepend that to PATH when the task needs them.

Briefing it:

- Say which facts to return, and demand a citation for each — a URL, or a
  `file:line`.
- Ask for verbatim quotes wherever exact spelling matters: API options, flags,
  version numbers. A digest paraphrases them away.
- The `web-fetch` skill holds the search tool selection; name the choice rather
  than leaving it open.
