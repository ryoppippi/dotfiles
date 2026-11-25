# Inside T3 Code

Follow the `t3-delegate` skill instead of running `grok -p` or
`codex exec`, with `interactionMode: "plan"`:

- Tweet search: the `grok` provider on its default model.
- Escalated search: the `codex` provider and the newest luna model. Tell it not
  to use `agent-browser`; a search subagent must not launch a browser.

## exa and TinyFish keys

Get each key once per task as a file, and read that path inside each command:

1. Write it with one bounded read, `umask 077; timeout 15 op read <ref> >
   ~/.t3/userdata/secrets/files/<task>-<service>-key`. This location is
   approved for keys; write them nowhere else.
2. If that fails or times out, ask the user once with `request_secret` and
   `delivery: "file"`, and use the path it returns.

Reuse the file for the whole task, and hand its path, never the key, to
subagents and workflow agents. Call `op read` at most once per key per task.
Delete the files you wrote with `op read` when the task ends.
