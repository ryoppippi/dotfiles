# Review outside T3 Code

Run Codex from Claude Code and Claude Code from Codex, as one read-only call per
round with the brief and ledger from `SKILL.md`. Never start the CLI of the
harness you are running in. Each CLI's `--help` carries the rest.

## Codex

Use `codex exec` with the complete brief from `SKILL.md`, including the selected
scope, so root-cause criteria and reporting requirements reach the reviewer. The
`ask-other-agent` skill's `scripts/codex-model.nu` resolves the newest slug of a
family. Select the first available family from `SKILL.md`'s reviewer list
before invoking the command; report if none is available:

```sh
codex exec --sandbox read-only \
  -m "$("<ask-other-agent-dir>/scripts/codex-model.nu" "<selected-family>")" "<brief>"
```

## Claude Code

```sh
claude -p --model opus --permission-mode plan "<brief>"
```
