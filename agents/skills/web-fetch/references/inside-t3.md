# Inside T3 Code

Follow the `t3-delegate` skill instead of running `grok -p` or
`codex exec`, with `interactionMode: "plan"`:

- Tweet search: the `grok` provider on its default model.
- Escalated search: the `codex` provider and the newest luna model. Tell it not
  to use `agent-browser`; a search subagent must not launch a browser.

## exa and TinyFish keys

Do not call `op read` here: every new process prompts for approval, and a
research run triggers it every few seconds. Ask for the key once with
`request_secret` and `delivery: "file"`, then read the returned path inside each
command, e.g. `key=$(cat <file>)` or `Bun.file(path).text()`. The file lasts
24 hours, so reuse it for the whole task instead of asking again; ask again
only after it expires.
