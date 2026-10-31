## Delegating Work

- Hand work whose output is bulky but whose conclusion is small — web search, page reading, codebase investigation, summarising long output, drafting a commit message — to your own native subagent (the Agent tool in Claude Code, a native subagent in Codex). Keep here what needs this conversation's history, and every edit to the repo.
- Never start a nested CLI of the agent you are running in. For another vendor's independent opinion, use the `ask-other-agent` skill; inside T3 Code, reach other providers or models through the `t3-code-delegation` skill.
- Codex is the exception for edits: the main session (a sol model at high effort) plans, splits, and reviews, and hands each implementation step to a luna subagent with a self-contained brief (files, intended change, how to verify), then checks its diff.
