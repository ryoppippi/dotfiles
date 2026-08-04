## Delegating Work

Work whose output is bulky but whose conclusion is small — web search, page
reading, codebase investigation, summarising long output, drafting a commit
message from a diff — belongs in a cheap subagent, not in this context.
A `codex exec` subagent runs it on the Codex subscription; the `ask-codex` skill
covers how to brief it.

What stays here: anything that needs this conversation's own history, and every
edit to the repo.
