---
name: web-fetch
description: Fetches and extracts web content with the repository's preferred CLI, browser, and transcript tools. Use when a task needs text from a URL, web discovery, or social/video content.
---

# Web Fetch

- For static URLs, discovery, and text extraction, use `./ax <url>`. Read `./ax --help` for current syntax.
- For X/Twitter, Bluesky, and YouTube posts or transcripts, use `./tgrab <url>`.
- Use `./tgrab --lang ja <youtube-url>` when a Japanese YouTube transcript is preferred.
- If `ax` or `tgrab` fails, use the host's web fetch/search tool or `curl` for simple HTTP retrieval.
- Use Browser/`agent-browser` for JavaScript, navigation, interaction, login, testing, or screenshots; use Chrome MCP for an existing signed-in session.

Always run `./ax` and `./tgrab` via a subagent to keep the main conversation context clean.

Supported `tgrab` URL patterns include YouTube (`youtube.com/watch`, `youtu.be`, and embeds), X/Twitter status URLs, and Bluesky post URLs.
