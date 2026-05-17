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

## Social Media Posts & YouTube Transcripts

For X/Twitter, Bluesky, and YouTube, use [tgrab](https://github.com/ryoppippi/tgrab):

```sh
nix run github:ryoppippi/tgrab -- <url>
```

Always fetch via a subagent to keep the main conversation clean. See the tgrab README for supported URL patterns and options.

## Tips

- if you use `gh do` command, you can pass github credentials via environment variables. See `gh do --help` for more details.

## Shell

- Always use `fish` shell for interactive commands `fish -c "<command>"` instead of `zsh -c "<command>"` or `bash -c "<command>"`.
