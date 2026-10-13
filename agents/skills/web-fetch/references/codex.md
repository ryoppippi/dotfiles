# codex

For a Codex Desktop or Codex CLI session, delegate the search to a native
subagent. Do not run `codex exec` from inside Codex; keep the model, effort,
and service tier from Codex's own config.

Outside Codex, use the CLI:

```sh
codex exec --skip-git-repo-check --ephemeral --sandbox read-only \
  -m "$(<ask-coding-cli skill dir>/scripts/codex-model.nu)" -c service_tier=fast \
  "<search prompt>. Do not use agent-browser; use your native web search."
```

`codex-model.nu` resolves the latest luna model from Codex's catalog; the
`ask-coding-cli` skill covers the rest of the Codex CLI flags.

Always tell codex not to use `agent-browser` — its native web search is enough, and a browser must not be launched from a search subagent.
