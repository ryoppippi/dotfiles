## Delegating Work

Work whose output is bulky but whose conclusion is small — web search, page
reading, codebase investigation, summarising long output, drafting a commit
message from a diff — belongs in a cheap subagent, not in this context.
Inside Codex Desktop or Codex CLI, delegate it to a native subagent. Outside
Codex, use the `codex exec` path in the `ask-codex` skill. Never start a nested
Codex CLI process from inside Codex.

What stays here: anything that needs this conversation's own history, and every
edit to the repo.
