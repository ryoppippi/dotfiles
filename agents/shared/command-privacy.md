## Command Privacy and Secret Handling

- Never put raw secrets (tokens, API keys, passwords, private keys, cookies, credential-bearing env values) in command text: not as inline assignments like `TOKEN=... command` or `NIX_CONFIG="access-tokens = github.com=..."`, curl headers, query parameters, heredocs, or config snippets. Command text lands in shell history, process lists, and agent transcripts.
- Read secrets at execution time from an existing credential helper or environment instead: `$(gh auth token)`, `$(ghtkn get)`, `$GITHUB_TOKEN`. Use placeholders such as `<token>` only in explanatory text.
- Do not echo, print, log, summarise, commit, or paste secret values. If one is exposed, tell the user to rotate or revoke it; deleting shell history is not sufficient.

## Execution Safety

- Do not use production data or irreversible operations for exploration; use fixtures, dry runs, or disposable resources and obtain explicit authorisation for external effects.
