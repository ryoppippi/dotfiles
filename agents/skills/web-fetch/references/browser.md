# Browser

Last resort. Exhaust `ax`, `tgrab`, `grok`, `codex`, and `exa` first; a browser is only for a page that genuinely needs one — JavaScript rendering, a login, or interaction.

Then pick in this order:

1. **The host's own browser, when there is one.** Under cmux that is the `cmux-browser` skill; the Codex and Claude desktop apps have a built-in browser too. It reuses the session already in front of the user and starts no extra process.
2. **Otherwise the `agent-browser` skill.** It drives real Chrome over CDP and handles sessions and stored credentials itself, so signed-in pages work without reaching for Chrome MCP.

Either way keep it in the background — headless is the default, so never pass `--headed` for a fetch.
