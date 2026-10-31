---
name: web-fetch
description: When reading a URL, searching the web or X, or fetching social posts and YouTube transcripts.
---

# Web Fetch

With a URL in hand:

- Static page text: `./ax <url>`; `./ax agent-context` has its full guide.
- X/Twitter, Bluesky, YouTube posts and transcripts: `./tgrab <url>`; see
  `./tgrab --help`.

Searching, in this order:

1. `exa` — semantic search plus extraction in one call; it returns sources to
   judge rather than a conclusion to trust. [references/exa.md](references/exa.md)
2. `grok -p "<prompt>"` — tweet search through its native X index; feed the URLs
   to `./tgrab` for full content.
3. `codex` — escalation for multi-step digging or synthesis, when exa's results
   are ambiguous, or when exa's 1Password key is unavailable.
   [references/codex.md](references/codex.md)

Inside T3 Code, run grok and codex as
[references/inside-t3.md](references/inside-t3.md) describes.

If `ax` or `tgrab` fails, fall back to the host's web fetch tool or `curl`. A
browser is the last resort, for pages that need JavaScript, a login, or
interaction: [references/browser.md](references/browser.md).

Delegate the reading, not only the fetching: give the whole task to your own
subagent and ask for a digest, so whole pages never enter this context. Two
things stay here: `exa`, whose key no Codex sandbox reaches, and anything needed
verbatim, such as API docs, where a digest rewrites the exact names you came for.
