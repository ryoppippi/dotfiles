# Ask another agent outside T3 Code

Each CLI's `--help` carries the flags. Plan or read-only modes below keep an
opinion read-only; drop them only when the user hands the agent a task.

## Codex

```sh
codex exec --skip-git-repo-check --ephemeral --sandbox read-only \
  -m "$("<skill-dir>/scripts/codex-model.nu")" -c service_tier=fast "<task>"
```

For an explicitly requested edit task, use `--sandbox workspace-write`.

Measured, and not visible in the help output:

- Keep `model_reasoning_effort` at `medium` or above; at `low` it answered a
  "latest release" search from stale knowledge.
- Never `--disable multi_agent`: native web search runs through it, and a search
  task hangs without it.
- Shell commands reach the network only under `--sandbox workspace-write` with
  `-c sandbox_workspace_write.network_access=true`; native web search needs
  neither.
- `exa` cannot run there (no sandbox reaches its 1Password key), so run it in
  this session. `ax` and `tgrab` live in `~/.agents/skills/web-fetch/`; prepend
  that to PATH when needed.

## Claude Code

```sh
claude -p --model fable --permission-mode plan "<question>"
```

`claude -p` is billed per use; keep it for decisions worth a second opinion.
`--output-format json` shows the resolved model under `modelUsage`.

## Grok

```sh
grok -p "<question>"
```

For searching X, use the `web-fetch` skill instead.

## Cursor

```sh
cursor-agent -p --mode plan "<question>"
```
