---
name: ask-coding-cli
description: Gets an independent second opinion from another coding agent CLI — Codex, Claude Code, Grok, or Cursor — or hands one a task the user names it for. Use when the user asks for one of them, or before a significant approach is settled — not for routine searches, which go to the current agent's own subagents.
---

<!--
Example prompts:
  /ask-coding-cli Review my implementation plan
  /ask-coding-cli Ask codex whether this error handling is right
  /ask-coding-cli Get claude's take on this migration
-->

# Ask a Coding CLI

Use the agent the user names. Otherwise pick one that is not the agent you are
running in — Codex from Claude Code, Claude Code from Codex — since a second
opinion from the same model adds little.

Never start the CLI of the agent you are running in; that nests a whole session.
For your own agent, use its native subagent instead (the Agent tool in Claude
Code, a native subagent in Codex).

Every path takes a self-contained prompt: the other agent sees none of this
conversation, so whatever it cannot infer has to be in the prompt. Keep it
focused — the relevant files, the decision at stake, and the constraints —
rather than dumping the whole codebase.

## Inside T3 Code

When the `t3-code` MCP tools are available (`delegate_task`, possibly
normalised to `mcp__t3_code__delegate_task`), use them instead of every CLI
below; the CLIs are the fallback when those tools are absent. T3 runs the other
agent as a child thread the user can watch, and its completion wakes this
thread instead of blocking a shell.

1. Call `orchestrator_capabilities` and pick the provider instance and model
   from its live catalog, applying the same model choice as the sections
   below. Always pass `target.model`: a provider without one falls back to its
   first advertised model, not its newest.
2. Call `delegate_task` with the self-contained prompt as `task`,
   `mode: "async"`, and a `role` such as `review`, `research`, or `design`.
   `role` only prefixes the prompt, so keep a second opinion read-only with
   `interactionMode: "plan"` and say so in the task; drop plan mode only when
   the user hands the agent a task to carry out.
3. Leave `runtimeMode` unset. Approval-requiring modes stall the child on a
   prompt this thread cannot answer.
4. Leave `isolation` at the default shared checkout when the task concerns
   uncommitted work; a worktree starts from the last commit.
5. End the turn and wait for the completion notification rather than polling.
   For another round, call `delegate_task` again with the original brief, the
   earlier findings, and your responses, under a new `clientRequestId`; do not
   continue through `t3_thread_send` on the child thread.

## Codex

Always run the latest luna model on the fast service tier — a small model gains
most from the lower latency. `scripts/codex-model.nu` in this skill's directory
resolves the newest slug of a family (default `luna`) from Codex's live catalog,
so no model name is pinned here:

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
`fable`, `opus`, `sonnet`, and `haiku` each map to the newest model of that tier,
so pass an alias, never a full model ID. `--output-format json` reports the
resolved ID under `modelUsage` when you need to confirm it. `claude -p` is billed
per use, so reserve it for decisions worth a second opinion rather than grunt
work.

## Grok

```sh
grok -p "<question>"
```

Grok's default is already its latest model (`grok models` lists them), so pass no
`-m`. For searching X, use the `web-fetch` skill instead; that is where Grok's
native X index earns its place.

## Cursor

```sh
cursor-agent -p --mode plan "<question>"
```

Leave the model on `auto`, Cursor's default, which routes to its current models;
`cursor-agent models` lists the alternatives when the user names one.

`--mode plan` (and `--permission-mode plan` for Claude Code) keeps a second
opinion read-only; drop it only when the user hands the agent a task to carry
out.

## Briefing and using the answer

- Say which facts to return, and demand a citation for each — a URL, or a
  `file:line`.
- Ask for verbatim quotes wherever exact spelling matters: API options, flags,
  version numbers. A digest paraphrases them away.
- For a second opinion, ask for an independent assessment rather than agreement
  with your plan.

Treat the reply as one data point: compare it against your own reading of the
codebase, report both views to the user with the disagreements intact, and
prefer established project patterns where they conflict. Let the user make the
final call.
