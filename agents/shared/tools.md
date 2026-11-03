## Tools

Prefer `rg` over grep, `fd` over find, `bat` over cat, `eza` over ls, `dust` over du, `bunx` over npx, `uv run` over `python`, and `gh` for anything on GitHub. Use `jq` for JSON, `typos` for spelling, and the `ast-grep` skill for structural code search.

When a command is missing, use the `missing-tools` skill; never install tools globally.

### Shell

Fish bootstraps the environment; it is not necessarily the syntax shell.

- Claude Code: run commands directly; its zsh already loads PATH and direnv. Use `fish -lc '<command>'` only when a tool is found on Fish's PATH but not here.
- Codex: use `zsh -lc '<command>'`; it loads direnv. If a tool is only on Fish's PATH, resolve it with `fish -lc 'command -v <tool>'` and call the absolute path.
- Commands already start in the working directory, so don't add a redundant `cd <path> &&`. For another directory, use the harness's working-directory parameter where it has one, or the command's own option (`git -C`, `pnpm -C`); tools that read config or direnv from the working directory need one of these, not just absolute paths.

### Web, Browsers, and Other Repositories

- For web pages, search, X/Twitter, Bluesky, and YouTube, use the `web-fetch` skill.
- Inside cmux (`$CMUX_SURFACE_ID` is set), open a URL meant for the user with `cmux browser open <url>`. Sign-in, OAuth, and device-code URLs go to the system browser with `open <url>`, where the sessions live.
- For browser automation, use the host's own browser first (Codex Desktop's Browser plugin, the `cmux-browser` skill), then the `agent-browser` skill. Use the user’s existing Chrome session when the task needs its cookies, extensions, or tabs; JavaScript rendering alone can use the fallback browser.
- Read a few files of another repository with `gh repo read-file` / `gh repo read-dir`. For broad searches, history, or builds, get a local reference with `ghq get <repository>`. Refresh an existing clone with `git fetch`, inspect the relevant fetched ref, and keep local work intact. Treat it as a read-only reference.
- `gh do` passes GitHub credentials through environment variables; see `gh do --help`.
