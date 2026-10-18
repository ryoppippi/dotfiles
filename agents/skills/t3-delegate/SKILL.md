---
name: t3-delegate
description: Delegates a task to another provider or model as a T3 Code child task through `delegate_task`. Use inside T3 Code whenever a skill would otherwise shell out to `codex`, `claude -p`, `grok -p`, or `cursor-agent`.
---

# Delegate inside T3 Code

T3 Code injects the `t3-code` MCP server into every thread it runs, and its
`t3-code:delegate_task` tool runs another provider as a child thread the user
can watch. Inside T3, use it instead of the agent CLIs; outside T3, the calling
skill's CLI path still applies.

The tools are present when `t3-code:delegate_task` is listed, possibly
normalised to `mcp__t3_code__delegate_task` or deferred behind a tool search.
If the catalogue does not show them, make one direct
`t3-code:orchestrator_capabilities` call before falling back to a CLI.

For your own provider, keep using the native subagent when it can run the
model you want; `delegate_task` is for other providers and for models the
native subagent cannot run.

## Workflow

1. Call `t3-code:orchestrator_capabilities` and take the provider instance and
   model from its live catalogue, applying the calling skill's model choice.
   Always pass `target.model`: a provider without one falls back to its first
   advertised model, not its newest.
2. Write a self-contained `task`. The child sees none of this conversation, so
   name the files, the decision at stake, the constraints, and the shape of the
   answer you want back.
3. Call `t3-code:delegate_task`:
   - `role`: `review`, `research`, `design`, or another fitting role. It only
     prefixes the prompt.
   - `interactionMode: "plan"` for anything read-only, and say "do not edit
     files" in the task as well. Drop it only when the user hands the child a
     change to make.
   - `runtimeMode`: leave unset. Approval-requiring modes stall the child on a
     prompt this thread cannot answer.
   - `isolation`: leave at the default shared checkout when the task concerns
     uncommitted work; `worktree` starts from the last commit.
   - `mode`: `"wait"` when the answer gates your next step — a review before a
     PR, a search digest the current task needs. Otherwise `"async"`: end the
     turn and let the completion notification wake this thread instead of
     polling.
   - `clientRequestId`: a fresh, stable ID per round, so retries do not start
     duplicate work.
4. For another round, call `delegate_task` again with the original brief, the
   earlier findings, and your responses. Do not continue through
   `t3-code:t3_thread_send` on the child thread.
5. Link the child for the user as `[title](t3-thread://v1/<childThreadId>)`.

A `wait` that returns `hasPendingQuestion` needs an answer through
`t3-code:t3_pending_request_respond` with `threadId` set to the child thread,
or from the user. A `waitTimedOut` result leaves the child running; read it
later with `t3-code:task_status`.

## Reference

The tool descriptions are authoritative. For design background, read
https://github.com/pingdotgg/t3code/blob/main/docs/orchestration-v2/orchestrator-mcp-server.md
