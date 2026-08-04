## Delegating Work

Work whose output is bulky but whose conclusion is small — web search, page
reading, codebase investigation, summarising long output, drafting a commit
message from a diff — belongs in a cheap subagent, not in this context.
`pi-sub "<task>"` runs it on the Codex subscription; the `pi-subagent` skill
covers how to write the task.

What stays here: anything that needs this conversation's own history, and every
edit to the repo.
