# agent-browser

Constraints that apply when a fetch or search task hands off to the `agent-browser` skill; that skill covers its own usage.

- Keep it in the background: headless is the default, so never pass `--headed`.
- Prefer Chrome MCP when an existing signed-in session is needed.
