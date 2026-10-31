# Review inside T3 Code

Follow the `t3-code-delegation` skill with `role: "review"` and the brief from
`SKILL.md`, rather than shelling out to any CLI.

From a Claude thread, delegate to the Codex provider; from a Codex thread, to the
Claude provider. Add Grok (default model) or Cursor (`auto`) only when a further
opinion is worth it. From other providers, choose Codex or Claude, respecting
the user’s provider restrictions and the live catalogue.
