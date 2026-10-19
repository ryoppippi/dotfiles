# Review outside T3 Code

Run Codex from Claude Code and Claude Code from Codex. Add Grok or Cursor only when a further opinion is worth it. Never start the CLI of the harness you are running in; use its native subagent instead.

## Codex

`scripts/codex-model.nu` in the `ask-coding-cli` skill's directory resolves the newest slug of a family. The positional prompt cannot be combined with a scope flag:

```sh
codex exec review --base main -m "$(<ask-coding-cli-dir>/scripts/codex-model.nu astra)"
```

## Claude Code

```sh
claude -p --model opus --permission-mode plan "<brief>"
```

## Grok

Grok's default is already its latest model, so pass no `-m`:

```sh
grok -p "<brief>"
```

## Cursor

Leave the model on `auto`, Cursor's default:

```sh
cursor-agent -p --mode plan "<brief>"
```

Each CLI's `--help` carries the rest.
