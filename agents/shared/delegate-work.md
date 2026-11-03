## Delegating Work

- Hand work whose output is bulky but whose conclusion is small — web search, page reading, codebase investigation, summarising long output, drafting a commit message — to your own native subagent (the Agent tool in Claude Code, a native subagent in Codex). Keep here what needs this conversation's history.
- Never start a nested CLI of the agent you are running in. For another vendor's independent opinion, use the `ask-other-agent` skill; inside T3 Code, reach other providers or models through the `t3-delegate` skill.
- Implementation may be delegated when the brief is cheaper than the work: plan and split here, hand a well-specified step to a subagent or child thread with a self-contained brief (files, intended change, how to verify), then check its diff. Match the model to the task — a simple, well-specified step can go to a cheaper model — and when doing it yourself is quicker than writing the brief, do it yourself.
- Review runs the other way: when possible, send it to a strong model from another vendor (`cross-model-review` skill).
- Claude Code's permission checker rejects compound commands (`cd … && … | …`) from a subagent in an isolated worktree, because it cannot prove they stay inside it. Brief such a subagent to run one simple command per call and to use `git -C`.
