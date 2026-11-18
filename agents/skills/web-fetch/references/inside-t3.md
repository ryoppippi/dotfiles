# Inside T3 Code

Follow the `t3-delegate` skill instead of running `grok -p` or
`codex exec`, with `interactionMode: "plan"`:

- Tweet search: the `grok` provider on its default model.
- Escalated search: the `codex` provider and the newest luna model. Tell it not
  to use `agent-browser`; a search subagent must not launch a browser.

## exa and TinyFish keys

Try 1Password first, bounded: `timeout 15 op read <ref>`. If it fails or times
out, nobody is at the machine to approve it; ask the user once with
`request_secret` and `delivery: "file"`, then read the returned path inside each
command, e.g. `key=$(cat <file>)` or `Bun.file(path).text()`. The file lasts
24 hours: reuse it for the whole task, and ask again only after it expires.

Once 1Password has prompted, do not call `op read` again for the same task; a
second prompt means every command will prompt, so switch to `request_secret`.
