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

## Opening URLs

Inside cmux (`$CMUX_SURFACE_ID` is set), open a URL the user is meant to look at — a pull request, a preview deployment, docs — as a browser surface beside the terminal:

```sh
cmux browser open <url>
```

Prefer it over `gh pr view --web` and `open <url>`, which hand the URL to the system browser and lose the split. Resolve the URL without opening it first, e.g. `gh pr view --json url -q .url`. For anything past opening a page, use the `cmux-browser` skill.

Authentication is the exception. Send sign-in, OAuth, and device-code URLs to the system browser with `open <url>`: that is where the sessions, password manager, and passkeys are, and a fresh embedded session has none of them.

## Reading Files from GitHub Repos

For a handful of known files, read them remotely instead of cloning:

```sh
nix run nixpkgs#gh -- repo read-file --help
nix run nixpkgs#gh -- repo read-dir --help
```

## Cloning Repos for Investigation (ghq)

When the task needs a whole repo locally — searching across it, following its git
history, or running its build and tests — clone it with `ghq` instead of
`git clone` into `/tmp` or inside the current project. See `ghq --help` for usage.

Treat such clones as read-only reference checkouts: never commit or push to a
repo that was cloned just to be investigated.
