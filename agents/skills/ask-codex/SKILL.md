---
name: ask-codex
description: Runs Codex CLI for a second opinion on a decision, or as a cheap subagent via codex-sub. Use before a significant approach is settled, or instead of reading pages and long output here.
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
codex-sub "<task>"
```

For work whose output is bulky but whose conclusion is small: web search, page
reading, codebase investigation, summarising long output, drafting a commit message
from a diff. The wrapper pins a cheap model, a sandbox with network access and no
persisted session, then prints only the final message — a failure prints the
transcript on stderr instead. `CODEX_SUB_MODEL`, `CODEX_SUB_EFFORT` and
`CODEX_SUB_SANDBOX` override the defaults.

Briefing it:

- Say which facts to return, and demand a citation for each — a URL, or a
  `file:line`.
- Ask for verbatim quotes wherever exact spelling matters: API options, flags,
  version numbers. A digest paraphrases them away.
- `ax`, `tgrab`, `grok`, `rg`, `fd` and `bun` are on its PATH, and the `web-fetch`
  skill holds the search tool selection. `exa` is the exception — the sandbox
  cannot reach its 1Password key, so run exa here.
