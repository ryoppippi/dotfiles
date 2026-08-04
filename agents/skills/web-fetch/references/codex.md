# codex

General web search:

```sh
codex exec --skip-git-repo-check --ephemeral --sandbox read-only -m gpt-5.6-luna "<search prompt>. Do not use agent-browser; use your native web search."
```

Always tell codex not to use `agent-browser` — its native web search is enough, and a browser must not be launched from a search subagent.
