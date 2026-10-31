# codex

From a Codex session, delegate the search to a native subagent instead of
running `codex exec`. Elsewhere outside T3 Code, use the CLI:

```sh
codex exec --skip-git-repo-check --ephemeral --sandbox read-only \
  -m "$(<ask-other-agent skill dir>/scripts/codex-model.nu)" -c service_tier=fast \
  "<search prompt>. Do not use agent-browser; use your native web search."
```

Always tell it not to use `agent-browser`: native web search is enough, and a
search subagent must not launch a browser. The `ask-other-agent` skill covers
the other Codex CLI flags.
