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

## Shell Fallback

Fish is the environment bootstrap shell, not necessarily the syntax shell.

Use `fish -lc '<simple command>'` for simple commands so PATH and exported environment are initialised consistently.

If a command depends on bash/zsh syntax, run that shell from Fish so the environment is inherited, for example:

```sh
fish -lc 'bash -lc "<posix command>"'
```

If `bunx <command>` fails, try: `bun x <command>`

## Missing Tools

Use the `missing-tools` skill when a command is unavailable, a shell reports `command not found`, or a tool must be run without installing it globally.

## Tips

- if you use `gh do` command, you can pass github credentials via environment variables. See `gh do --help` for more details.
