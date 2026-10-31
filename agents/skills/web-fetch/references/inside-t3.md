# grok and codex inside T3 Code

Follow the `t3-code-delegation` skill instead of running `grok -p` or
`codex exec`, with `interactionMode: "plan"`:

- Tweet search: the `grok` provider on its default model.
- Escalated search: the `codex` provider and the newest luna model. Tell it not
  to use `agent-browser`; a search subagent must not launch a browser.
