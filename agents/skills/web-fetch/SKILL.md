---
name: web-fetch
description: Fetches and searches web content with ax, tgrab, grok, codex, exa, and agent-browser. Use for text from a URL, web/tweet/semantic search, or social/video content.
---

# Web Fetch

Pick the tool by task, then read its reference for usage:

- Static URL text and discovery: `./ax` — [references/ax.md](references/ax.md)
- X/Twitter, Bluesky, YouTube posts/transcripts by URL: `./tgrab` — [references/tgrab.md](references/tgrab.md)
- Tweet search without a URL: `grok` — [references/grok.md](references/grok.md)
- General web search: `codex` — [references/codex.md](references/codex.md)
- Semantic search with filters, or LLM-ready extraction: `exa-js` — [references/exa.md](references/exa.md)
- JavaScript, login, interaction, screenshots, or search in the background: `agent-browser` — [references/agent-browser.md](references/agent-browser.md)

If `ax` or `tgrab` fails, fall back to the host's web fetch/search tool or `curl`.

Always run these CLIs via a subagent to keep the main conversation context clean.
