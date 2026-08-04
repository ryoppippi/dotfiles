---
name: web-fetch
description: Fetches and searches web content with ax, tgrab, grok, codex, and exa. Use for text from a URL, web/tweet/semantic search, or social/video content.
---

# Web Fetch

With a URL in hand:

- Static page text: `./ax` — [references/ax.md](references/ax.md)
- X/Twitter, Bluesky, YouTube posts/transcripts: `./tgrab` — [references/tgrab.md](references/tgrab.md)

Searching, in this order:

1. `exa` — semantic search with filters, plus extraction in the same call. Default choice: one HTTP round trip, and it returns sources to judge rather than a conclusion to trust. [references/exa.md](references/exa.md)
2. `grok` — tweet search; it has the native X index. [references/grok.md](references/grok.md)
3. `codex` — escalation, not a first stop: it spawns a reasoning agent, so use it when the question needs multi-step digging or synthesis across sources, when exa's results are ambiguous and an independent reading helps, or when the 1Password key exa needs is unavailable. [references/codex.md](references/codex.md)

If `ax` or `tgrab` fails, fall back to the host's web fetch/search tool or `curl`.

A browser is the last resort, only for a page the tools above cannot read — JavaScript rendering, a login, or interaction. Which browser to reach for, in order: [references/browser.md](references/browser.md).

Always run these CLIs via a subagent to keep the main conversation context clean.
