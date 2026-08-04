---
name: web-fetch
description: Fetches and searches web content with ax, tgrab, grok, codex, and exa. Use for text from a URL, web/tweet/semantic search, or social/video content.
---

# Web Fetch

With a URL in hand:

- Static page text: `./ax <url>`; run `./ax agent-context` for the full agent-facing guide
- X/Twitter, Bluesky, YouTube posts/transcripts: `./tgrab <url>`; `./tgrab --help` carries the agent contract

Searching, in this order:

1. `exa` — semantic search with filters, plus extraction in the same call. Default choice: one HTTP round trip, and it returns sources to judge rather than a conclusion to trust. [references/exa.md](references/exa.md)
2. `grok -p "<prompt>"` — tweet search; it has the native X index. Feed the URLs it returns to `./tgrab` when full content is needed.
3. `codex` — escalation, not a first stop: it spawns a reasoning agent, so use it when the question needs multi-step digging or synthesis across sources, when exa's results are ambiguous and an independent reading helps, or when the 1Password key exa needs is unavailable. [references/codex.md](references/codex.md)

If `ax` or `tgrab` fails, fall back to the host's web fetch/search tool or `curl`.

A browser is the last resort, only for a page the tools above cannot read — JavaScript rendering, a login, or interaction. Which browser to reach for, in order: [references/browser.md](references/browser.md).

Delegate the reading, not only the fetching: `codex-sub "<task>"` runs its own web search, `./ax`, `./tgrab` and `grok` on the Codex subscription and hands back a digest, so whole pages and JSON payloads never enter this context — see the `ask-codex` skill. Two things stay here: `exa`, whose 1Password key the subagent's sandbox cannot reach, and anything wanted verbatim, such as the exa docs pages above, where a digest rewrites the exact names you came for.
