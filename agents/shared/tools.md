# Preferred Tools

Use these tools instead of their standard alternatives:

| Tool             | Replaces | Description         |
| ---------------- | -------- | ------------------- |
| `fish`           | bash     | Environment shell   |
| `rg`             | grep     | Fast search         |
| `fd`             | find     | File finder         |
| `bat`            | cat      | Syntax highlighting |
| `eza`            | ls       | Git-aware listing   |
| `dust`           | du       | Disk usage          |
| `typos`          | -        | Spell checker       |
| `bunx` / `bun x` | npx      | Package runner      |
| `jq`             | -        | JSON processor      |
| `gh`             | git      | GitHub CLI          |

For code pattern searches (constructs, structure, not plain text), use the `ast-grep` skill rather than `rg`.

Use the `missing-tools` skill when a command is unavailable, a shell reports `command not found`, or a tool must be run without installing it globally.

## Shell

Fish bootstraps the environment; it is not necessarily the syntax shell.

- **Codex**: use `zsh -lc '<simple command>'`. The dotfiles-managed Zsh environment loads direnv without requiring Fish syntax.
- **Claude Code**: run simple commands as `fish -lc '<command>'` so PATH and exports are initialised.
- Some user tools are only on Fish's PATH. If Zsh cannot find a command, resolve it with `fish -lc 'command -v <tool>'`, then invoke the absolute path.
- When a command needs bash syntax — fragile quoting, heredocs, arrays, inline environment assignments, command substitutions — use Bash explicitly rather than asking Fish to parse it: `fish -lc 'bash -lc "<posix command>"'`.
- For complex multi-line commands, prefer an existing script or create a temporary script with the right shebang, then invoke it with the appropriate interpreter.

## Python Execution

When executing Python scripts, always use `uv` instead of `python` directly:

```bash
# Use uv to run Python scripts
uv run script.py

# Or for inline execution
uv run python -c "print('hello')"
```

This ensures consistent Python environment management without requiring global Python installations.

## Opening URLs

Inside cmux (`$CMUX_SURFACE_ID` is set), open a URL the user is meant to look at — a PR, a preview deployment, docs — beside the terminal with `cmux browser open <url>` instead of `open` or `gh pr view --web`. Resolve the URL first (`gh pr view --json url -q .url`). For anything beyond opening a page, use the `cmux-browser` skill.

Authentication is the exception: send sign-in, OAuth, and device-code URLs to the system browser with `open <url>`, where the sessions and passkeys live.

## Reading Other Repositories

- A handful of known files: `gh repo read-file` / `gh repo read-dir` instead of cloning.
- A whole repo (searching, history, running builds): clone with `ghq` instead of `git clone` into `/tmp` or the current project. Treat the clone as read-only reference; never commit or push to it.

## Social Media Posts & YouTube Transcripts

For X/Twitter, Bluesky, and YouTube, use the `web-fetch` skill. It provides the packaged `tgrab` executable for fetching supported URLs.

Always fetch via a subagent to keep the main conversation clean. See the `web-fetch` skill for supported URL patterns and options.

## GitHub Credentials

If you use the `gh do` command, you can pass GitHub credentials via environment variables. See `gh do --help` for more details.
