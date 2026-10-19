# Ask a coding CLI outside T3 Code

Never start the CLI of the agent you are running in; that nests a whole session.
For your own agent, use its native subagent instead (the Agent tool in Claude
Code, a native subagent in Codex).

## Codex

Run the model from `SKILL.md` on the fast service tier:

```sh
codex exec --skip-git-repo-check --ephemeral \
  -m "$(<skill-dir>/scripts/codex-model.nu)" -c service_tier=fast "<task>"
```

Inside Codex, a native subagent takes `agents.default_subagent_model` from
`nix/modules/home/programs/codex/` instead.

`codex exec --help` carries the rest; reach for `-o` to capture the final message
alone, and `--sandbox`/`--add-dir` to widen what it may touch. Measured, and not
visible in the help output:

- Keep `model_reasoning_effort` at `medium` or above. At `low` it answered a
  "latest release version" search from stale knowledge.
- Never `--disable multi_agent`. Native web search runs through it, so disabling it
  makes a search task hang indefinitely with no tool call.
- Shell commands only reach the network under `--sandbox workspace-write` with
  `-c sandbox_workspace_write.network_access=true`. The native web search needs
  neither.
- `exa` cannot run there at all: no sandbox mode reaches its 1Password key, so run
  exa in this session. `ax` and `tgrab` live in `~/.agents/skills/web-fetch/` —
  prepend that to PATH when the task needs them.

## Claude Code

```sh
claude -p --model fable --permission-mode plan "<question>"
```

Claude Code has no model-list command; its aliases are the runtime resolution.
`--output-format json` reports the resolved ID under `modelUsage` when you need
to confirm it. `claude -p` is billed per use, so reserve it for decisions worth a
second opinion rather than grunt work.

## Grok

```sh
grok -p "<question>"
```

`grok models` lists the alternatives. For searching X, use the `web-fetch` skill
instead; that is where Grok's native X index earns its place.

## Cursor

```sh
cursor-agent -p --mode plan "<question>"
```

`cursor-agent models` lists the alternatives when the user names one.

`--mode plan` (and `--permission-mode plan` for Claude Code) keeps a second
opinion read-only; drop it only when the user hands the agent a task to carry
out.
