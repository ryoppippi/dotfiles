# User Memory

Personal preferences that apply to all projects.

## About Me

- My name is ryoppippi
- I prefer UK English spelling in all English text
- You can talk to me in any language, but all code-related output (commits, comments, docs, PRs) must be in English

## Code Comments Policy

- Before writing or reviewing code comments, read [Write "why" in comments](https://jisou-programmer.beproud.jp/%E9%96%A2%E6%95%B0%E8%A8%AD%E8%A8%88/10-%E3%82%B3%E3%83%A1%E3%83%B3%E3%83%88%E3%81%AB%E3%81%AF%E3%80%8C%E3%81%AA%E3%81%9C%E3%80%8D%E3%82%92%E6%9B%B8%E3%81%8F.html)
- If you need a paragraph-long comment to justify why the workaround is OK, the code is wrong — fix the code. (from [Rewriting Bun in Rust](https://bun.com/blog/bun-in-rust))

### Forbidden

- Do NOT add comments explaining what was changed or why a change was made
- Comments like `// changed from X to Y` or `// updated for feature Z` are forbidden
- If a change needs explanation, write it in the git commit message instead
- Git commits should contain detailed explanations of what changed and why
- Do NOT remove existing comments that explain logic, behaviour, or intent — even if they seem obvious to you. Only remove comments that are clearly outdated or factually wrong.

### Required

- **JSDoc**: Always write JSDoc comments for exported functions, classes, types, and interfaces. Include `@param`, `@returns`, and `@example` where appropriate.
- **Complex logic**: When a function or block contains non-trivial logic (algorithms, bitwise operations, state machines, multi-step transformations, etc.), add line-by-line comments explaining what each step does and why. The reader should be able to follow the logic without having to reverse-engineer it.
- Only skip comments for code that is truly self-explanatory (simple getters, one-liner utilities, etc.).

## Command Privacy and Secret Handling

- Before running any command, consider whether the command text, shell history, process list, terminal output, tool invocation log, or coding-agent transcript could contain a secret.
- Never put raw secrets, tokens, API keys, passwords, private keys, session cookies, or credential-bearing environment variable values directly in command strings.
- This includes inline assignments such as `TOKEN=... command`, `GITHUB_TOKEN=... command`, `NIX_CONFIG="access-tokens = github.com=..." command`, curl headers, query parameters, heredocs, config snippets, and debug commands.
- Prefer reading secrets at execution time from an existing credential helper, keychain-backed CLI, password manager, or already-present environment. Use command substitution such as `$(gh auth token)`, `$(ghtkn get)`, or existing variable references such as `$GITHUB_TOKEN` instead of pasting token values.
- Keep literal command text safe to store in shell history and agent transcripts. Use placeholders such as `<token>` only in explanatory text, never real secret values.
- Do not echo, print, log, summarise, commit, or paste secret values. If a raw secret is accidentally exposed, tell the user it should be rotated or revoked; deleting shell history is not sufficient.

## Git Worktrees

- Before invoking the `git-wt` skill to create or switch worktrees, compare
  `git rev-parse --path-format=absolute --git-dir` with
  `git rev-parse --path-format=absolute --git-common-dir`
- If the paths differ, the current directory is already a linked worktree; stay
  there and do not invoke `git-wt` unless the user explicitly requests a
  worktree lifecycle operation
- Use the `git-wt` skill only when a worktree lifecycle operation is actually
  needed
- Prefer `git wt` over raw `git worktree add`, `remove`, `move`, or `prune`
