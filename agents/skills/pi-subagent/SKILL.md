---
name: pi-subagent
description: Delegates search, page reading, codebase investigation, and summarising to a cheap pi subagent via pi-sub. Use instead of doing bulky-output work in this session.
---

# pi Subagent

`pi-sub "<task>"` runs a throwaway agent on the Codex subscription, so only the
digest it returns costs tokens here. Delegate work whose output is bulky but
whose conclusion is small: web search, page reading, codebase investigation,
summarising long output, drafting a commit message from a diff.

The wrapper pins an ephemeral session with no edit or write tools, and puts `ax`,
`tgrab`, `grok`, `rg`, `fd`, and `bun` on the agent's PATH — pass nothing but the
task. `PI_SUB_PROVIDER`, `PI_SUB_MODEL`, and `PI_SUB_THINKING` override the
defaults.

Writing the task:

- pi shares none of this conversation. Say what to do, which facts to return, and
  demand a citation per claim — a URL, or a `file:line`.
- pi discovers the same `~/.agents/skills`, so name the skill that applies —
  `web-fetch` to pick a searcher, `commit` for commit conventions.
- Ask for verbatim quotes of anything whose exact spelling matters — API options,
  flags, version numbers. A digest paraphrases them away.

`bash` is unsandboxed, so keep tasks read-only in intent and never put a secret
in the prompt; pi reads the exa key itself. When the raw text is the deliverable,
read it here instead.
