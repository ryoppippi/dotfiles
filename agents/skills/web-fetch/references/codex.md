# codex

For a Codex Desktop or Codex CLI session, delegate the search to a native
subagent. Do not run `codex exec` from inside Codex; use the configured
`gpt-5.6-luna` / `max` / `fast` defaults.

Outside Codex, use the CLI:

```sh
codex exec --skip-git-repo-check --ephemeral --sandbox read-only -m gpt-5.6-luna "<search prompt>. Do not use agent-browser; use your native web search."
```

Always tell codex not to use `agent-browser` — its native web search is enough, and a browser must not be launched from a search subagent.
