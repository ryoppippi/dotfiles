# Codex Global Instructions

## Code Comments Policy

- Do NOT add comments explaining what was changed or why a change was made
- Comments like `// changed from X to Y` or `// updated for feature Z` are forbidden
- Only add comments when the logic itself is genuinely complex and non-obvious
- If a change needs explanation, write it in the git commit message instead
- Git commits should contain detailed explanations of what changed and why

## Python Execution

When executing Python scripts, always use `uv` instead of `python` directly:

```bash
# Use uv to run Python scripts
uv run script.py

# Or for inline execution
uv run python -c "print('hello')"
```

This ensures consistent Python environment management without requiring global Python installations.

## Available Tools

The following tools are preferred and available globally:

- **Search**: Use `rg` (ripgrep) instead of grep
- **Find**: Use `fd` instead of find
- **JSON**: Use `jq` for JSON processing
- **Shell**: Fish shell is the primary shell

## Missing Tools

Use the `missing-tools` skill when a command is unavailable, a shell reports `command not found`, or a tool must be run without installing it globally.

## Command Privacy and Secret Handling

- Before running any command, consider whether the command text, shell history, process list, terminal output, tool invocation log, or coding-agent transcript could contain a secret.
- Never put raw secrets, tokens, API keys, passwords, private keys, session cookies, or credential-bearing environment variable values directly in command strings.
- This includes inline assignments such as `TOKEN=... command`, `GITHUB_TOKEN=... command`, `NIX_CONFIG="access-tokens = github.com=..." command`, curl headers, query parameters, heredocs, config snippets, and debug commands.
- Prefer reading secrets at execution time from an existing credential helper, keychain-backed CLI, password manager, or already-present environment. Use command substitution such as `$(gh auth token)`, `$(ghtkn get)`, or existing variable references such as `$GITHUB_TOKEN` instead of pasting token values.
- Keep literal command text safe to store in shell history and agent transcripts. Use placeholders such as `<token>` only in explanatory text, never real secret values.
- Do not echo, print, log, summarise, commit, or paste secret values. If a raw secret is accidentally exposed, tell the user it should be rotated or revoked; deleting shell history is not sufficient.

## Social Media Posts & YouTube Transcripts

For X/Twitter, Bluesky, and YouTube, use [tgrab](https://github.com/ryoppippi/tgrab):

```sh
nix run github:ryoppippi/tgrab -- <url>
```

Always fetch via a subagent to keep the main conversation clean. See the tgrab README for supported URL patterns and options.

## Tips

- if you use `gh do` command, you can pass github credentials via environment variables. See `gh do --help` for more details.

## Shell

- Fish is the environment bootstrap shell, not necessarily the syntax shell.
- Use `fish -lc '<simple command>'` for simple commands so PATH and exported environment are initialised consistently.
- Do not force Fish to parse complex POSIX shell syntax. If a command uses bash/zsh-specific syntax, fragile quoting, heredocs, arrays, inline environment assignments, or command substitutions, run the appropriate shell from Fish so the environment is inherited, for example `fish -lc 'bash -lc "<posix command>"'`.
- For complex multi-line commands, prefer an existing script or create a temporary script with the right shebang, then invoke it via `fish -lc 'bash ./script.sh'` or the appropriate interpreter.
