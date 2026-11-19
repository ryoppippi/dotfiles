# Browser

Only for a page the other tools cannot read — JavaScript rendering, a login, or
interaction.

1. The host's own browser when there is one: the Codex and Claude desktop
   apps' built-in browser. It reuses the session in front of the user.
2. Otherwise `ardia browse` or the `agent-browser` skill; both take
   agent-browser's commands.
   - `ardia browse` (`ardia browse --help`) drives the user's running Ardia,
     with their sessions and tabs. Use it when the page needs their login.
   - `agent-browser` drives a separate Chrome and handles sessions and stored
     credentials itself. Use it when Ardia is not running or the page needs no
     login.

Keep agent-browser headless; never pass `--headed` for a fetch.
