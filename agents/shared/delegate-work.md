## Delegating Work

Work whose output is bulky but whose conclusion is small — web search, page
reading, codebase investigation, summarising long output, drafting a commit
message from a diff — belongs in a subagent, not in this context. Delegate it
to the current agent's own native subagent: the Agent tool in Claude Code, a
native subagent in Codex. The `ask-coding-cli` skill is for an
independent second opinion from another agent, not routine delegation. Never start a
nested CLI process of the agent you are running in. Inside T3 Code, reach another
provider, or a model the native subagent cannot run, through the `t3-delegate`
skill rather than its CLI.

What stays here: anything that needs this conversation's own history, and every
edit to the repo.

**Codex** is the exception for edits: the main session runs a sol model at high
effort as the orchestrator, and its native subagents run luna at max effort.
Plan, split, and review there; hand each implementation step to a subagent with
a self-contained brief (files, intended change, how to verify), then check its
diff before moving on.
