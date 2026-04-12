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

**Always use [comma](https://github.com/nix-community/comma) first** when a tool is not installed:

```bash
, <command>           # Run any command from nixpkgs without installing
, cowsay "Hello"      # Example: run cowsay without installing it
, htop                # Example: run htop temporarily
```

Comma automatically finds and runs the package containing the command.

**Priority order** for running unavailable tools:

1. `direnv exec . <command>` - when you need environment variables from direnv
2. `, <command>` (comma) - preferred, simplest
3. `nix run nixpkgs#<package>` - when you need a specific package name
4. `nix shell nixpkgs#<package> --command <command>` - last resort

## Tips

- if you use `gh do` command, you can pass github credentials via environment variables. See `gh do --help` for more details.
