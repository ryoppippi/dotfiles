# Browser

Only for a page the other tools cannot read — JavaScript rendering, a login, or
interaction.

1. The host's own browser when there is one: the Codex and Claude desktop
   apps' built-in browser. It reuses the session in front of the user.
2. Ardia, when it is running: `ardia browse` takes agent-browser's commands
   (`ardia browse --help`) and reuses the user's sessions there.
3. Otherwise the `agent-browser` skill, which drives real Chrome and handles
   sessions and stored credentials itself.

Keep agent-browser headless; never pass `--headed` for a fetch.
