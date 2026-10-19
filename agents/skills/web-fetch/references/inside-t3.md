# grok and codex inside T3 Code

Follow the `t3-delegate` skill instead of running `grok -p` or `codex exec`:

- Tweet search: the `grok` provider on its default model.
- Escalated search: the `codex` provider and the newest luna model. Tell it not
  to use `agent-browser`; its native web search is enough, and a browser must
  not be launched from a search subagent.

Use `interactionMode: "plan"`; a search never needs to edit files.
