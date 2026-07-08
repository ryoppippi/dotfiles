# Codex Global Instructions

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

## Browser Automation

- In Codex Desktop, automatically use the installed Browser plugin (`@Browser`) for tasks that require opening, navigating, inspecting, testing, screenshotting, or verifying web pages, even when the user does not mention the plugin explicitly.
- Prefer the Browser plugin and the in-app browser over the standalone `agent-browser` skill whenever the Browser plugin is available.
- Use `agent-browser` only when the Browser plugin is unavailable or cannot handle the target, and briefly state the reason before falling back.
- Use Chrome instead when the task specifically requires an existing signed-in browser session, cookies, extensions, or the user's current Chrome tabs.

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

- Use `zsh -lc '<simple command>'` for agent commands. The dotfiles-managed Zsh environment loads direnv without requiring Fish syntax.
- Some user tools are only on Fish's PATH. If Zsh cannot find a command, resolve it with `fish -lc 'command -v <tool>'`, then invoke the absolute path from Zsh. Running a single simple command directly with `fish -lc` is also acceptable when it contains no shell-specific syntax.
- If a command uses Bash-specific syntax, fragile quoting, heredocs, arrays, inline environment assignments, or command substitutions, use Bash explicitly rather than asking Fish to parse it.
- For complex multi-line commands, prefer an existing script or create a temporary script with the right shebang, then invoke it with the appropriate interpreter.
