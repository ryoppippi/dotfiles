## Delegating Work

Work whose output is bulky but whose conclusion is small — web search, page
reading, codebase investigation, summarising long output, drafting a commit
message from a diff — belongs in a subagent, not in this context. Delegate it
to the current agent's own native subagent: the Agent tool in Claude Code, a
native subagent in Codex. The `ask-coding-cli` skill is for an
independent second opinion from another agent, not routine delegation. Never start a
nested CLI process of the agent you are running in.

What stays here: anything that needs this conversation's own history, and every
edit to the repo.
