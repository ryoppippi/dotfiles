# Review outside T3 Code

Run Codex from Claude Code and Claude Code from Codex; add Grok or Cursor only
when a further opinion is worth it. Never start the CLI of the harness you are
running in. Each CLI's `--help` carries the rest.

## Codex

Use `codex exec` with the complete brief from `SKILL.md`, including the selected
scope, so root-cause criteria and reporting requirements reach the reviewer. The
`ask-other-agent` skill's `scripts/codex-model.nu` resolves the newest slug of a
family:

```sh
codex exec --sandbox read-only \
  -m "$("<ask-other-agent-dir>/scripts/codex-model.nu" astra)" "<brief>"
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
