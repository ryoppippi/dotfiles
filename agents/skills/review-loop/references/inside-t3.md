# Review inside T3 Code

Follow the `t3-delegate` skill rather than shelling out to any CLI. Start every
round as a new `delegate_task` with `role: "review"` and a new
`clientRequestId`, carrying the brief and ledger from `SKILL.md`. Keep the
`taskId`; the `childThreadId` is not the next round's target.

From a Claude thread, delegate to the Codex provider; from a Codex thread, to
the Claude provider. From other providers, choose Codex or Claude, respecting
the user's provider restrictions and the live catalogue.

Wait for the task's completion notice; do not poll or start a second reviewer.
On failure, cancel the task, confirm it stopped, and restart with the ledger.
