# codex

General web search:

```sh
codex exec --skip-git-repo-check --sandbox read-only "<search prompt>. Do not use agent-browser; use your native web search."
```

Always tell codex not to use `agent-browser` — its native web search is enough, and a browser must not be launched from a search subagent.
