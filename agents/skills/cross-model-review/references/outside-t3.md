# Review outside T3 Code

Run Codex from Claude Code and Claude Code from Codex; add Grok or Cursor only
when a further opinion is worth it. Never start the CLI of the harness you are
running in. Each CLI's `--help` carries the rest.

## Codex

`codex exec review` takes a scope flag (`--uncommitted`, `--base <branch>`,
`--commit <sha>`) instead of the brief; the two cannot be combined. The
`ask-other-agent` skill's `scripts/codex-model.nu` resolves the newest slug of a
family:

```sh
codex exec review --base main -m "$(<ask-other-agent-dir>/scripts/codex-model.nu astra)"
```

## Claude Code

```sh
claude -p --model opus --permission-mode plan "<brief>"
```

## Grok and Cursor

```sh
grok -p "<brief>"
cursor-agent -p --mode plan "<brief>"
```
