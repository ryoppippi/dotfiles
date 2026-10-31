## Secrets and Safety

- Never put a secret (token, API key, password, private key, cookie, credential-bearing env value) in command text — inline assignments, headers, URLs, heredocs, config snippets. Command text lands in shell history, process lists, and transcripts. Read it at execution time instead: `$(gh auth token)`, `$(ghtkn get)`, `$GITHUB_TOKEN`.
- Never echo, print, log, summarise, paste, or commit a secret. If one is exposed, tell the user to rotate or revoke it; deleting history is not enough.
- Explore with fixtures, dry runs, or disposable resources, never production data or irreversible operations, and get explicit approval for external effects.
