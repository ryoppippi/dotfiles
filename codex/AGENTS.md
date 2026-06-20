# Codex Global Instructions

## Code Comments Policy

- Before writing or reviewing code comments, read [Write "why" in comments](https://jisou-programmer.beproud.jp/%E9%96%A2%E6%95%B0%E8%A8%AD%E8%A8%88/10-%E3%82%B3%E3%83%A1%E3%83%B3%E3%83%88%E3%81%AB%E3%81%AF%E3%80%8C%E3%81%AA%E3%81%9C%E3%80%8D%E3%82%92%E6%9B%B8%E3%81%8F.html)
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
- **Shell**: Use Zsh for agent commands; Fish remains the interactive shell and PATH fallback

## Missing Tools

Use the `missing-tools` skill when a command is unavailable, a shell reports `command not found`, or a tool must be run without installing it globally.

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

- Use `zsh -lc '<simple command>'` for agent commands. The dotfiles-managed Zsh environment loads direnv without requiring Fish syntax.
- Some user tools are only on Fish's PATH. If Zsh cannot find a command, resolve it with `fish -lc 'command -v <tool>'`, then invoke the absolute path from Zsh. Running a single simple command directly with `fish -lc` is also acceptable when it contains no shell-specific syntax.
- If a command uses Bash-specific syntax, fragile quoting, heredocs, arrays, inline environment assignments, or command substitutions, use Bash explicitly rather than asking Fish to parse it.
- For complex multi-line commands, prefer an existing script or create a temporary script with the right shebang, then invoke it with the appropriate interpreter.
