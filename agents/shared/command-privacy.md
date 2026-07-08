## Command Privacy and Secret Handling

- Before running any command, consider whether the command text, shell history, process list, terminal output, tool invocation log, or coding-agent transcript could contain a secret.
- Never put raw secrets, tokens, API keys, passwords, private keys, session cookies, or credential-bearing environment variable values directly in command strings.
- This includes inline assignments such as `TOKEN=... command`, `GITHUB_TOKEN=... command`, `NIX_CONFIG="access-tokens = github.com=..." command`, curl headers, query parameters, heredocs, config snippets, and debug commands.
- Prefer reading secrets at execution time from an existing credential helper, keychain-backed CLI, password manager, or already-present environment. Use command substitution such as `$(gh auth token)`, `$(ghtkn get)`, or existing variable references such as `$GITHUB_TOKEN` instead of pasting token values.
- Keep literal command text safe to store in shell history and agent transcripts. Use placeholders such as `<token>` only in explanatory text, never real secret values.
- Do not echo, print, log, summarise, commit, or paste secret values. If a raw secret is accidentally exposed, tell the user it should be rotated or revoked; deleting shell history is not sufficient.
