# Preferred Tools

Use these tools instead of their standard alternatives:

| Tool             | Replaces | Description         |
| ---------------- | -------- | ------------------- |
| `fish`           | bash     | Shell               |
| `rg`             | grep     | Fast search         |
| `fd`             | find     | File finder         |
| `bat`            | cat      | Syntax highlighting |
| `eza`            | ls       | Git-aware listing   |
| `dust`           | du       | Disk usage          |
| `typos`          | -        | Spell checker       |
| `bunx` / `bun x` | npx      | Package runner      |
| `jq`             | -        | JSON processor      |
| `gh`             | git      | GitHub CLI          |

## Shell Fallback

If a bash command fails, try: `fish -c <command>`

If `bunx <command>` fails, try: `bun x <command>`

## Missing Tools

Use the `missing-tools` skill when a command is unavailable, a shell reports `command not found`, or a tool must be run without installing it globally.

## Tips

- if you use `gh do` command, you can pass github credentials via environment variables. See `gh do --help` for more details.
