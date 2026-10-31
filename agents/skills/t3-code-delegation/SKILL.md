---
name: t3-code-delegation
description: When running inside T3 Code and work should go to another provider or model, instead of shelling out to `codex`, `claude -p`, `grok -p`, or `cursor-agent`.
---

# Delegate inside T3 Code

T3 Code injects the `t3-code` MCP server into its threads, and
`t3-code:delegate_task` runs another provider as a child thread the user can
watch. The tool descriptions are authoritative; this covers what they leave
implicit. Tools may be deferred: try the named tool before calling it absent.
If delegation is unavailable, report that limitation rather than switching
to a CLI or another provider without the user asking.

1. Call `t3-code:orchestrator_capabilities` and take the provider and model from
   its live catalogue. Always pass `target.model`: without it a provider falls
   back to its first advertised model, not its newest.
2. Write a self-contained `task`: the child sees none of this conversation, so
   name the files, the decision at stake, the constraints, and the answer shape.
3. Call `t3-code:delegate_task`:
   - `interactionMode: "plan"` for anything read-only, and say "do not edit
     files" in the task too.
   - Leave `runtimeMode` unset: approval-requiring modes stall the child on a
     prompt this thread cannot answer.
   - Select the shared checkout explicitly for uncommitted work; this repo
     defaults to `worktree`, which starts from the last commit.
   - `mode: "wait"` when the answer gates your next step; otherwise `"async"`,
     and let the completion notification wake you instead of polling.
   - A fresh, stable `clientRequestId` per round, so retries don't duplicate.
4. For another round, call `delegate_task` again with the original brief, the
   earlier findings, and your responses — not `t3_thread_send`.
5. Use the child thread link returned by T3 verbatim.

A `wait` returning `hasPendingQuestion` needs an answer via
`t3-code:t3_pending_request_respond` (with the child's `threadId`) or from the
user. Follow the tool response’s `next` instruction for a running child;
do not poll it.

Design background:
https://github.com/pingdotgg/t3code/blob/main/docs/orchestration-v2/orchestrator-mcp-server.md
