---
name: web-fetch
description: Fetches and extracts web content with the repository's preferred CLI, browser, and transcript tools. Use when a task needs text from a URL, web discovery, or social/video content.
---

# Web Fetch

- For static URLs, discovery, and text extraction, use `./ax <url>`. Read `./ax --help` for current syntax.
- If `ax` fails, use the host's web fetch/search tool or `curl` for simple HTTP retrieval.
- Use Browser/`agent-browser` for JavaScript, navigation, interaction, login, testing, or screenshots; use Chrome MCP for an existing signed-in session.
- Use `/tgrab` for X/Twitter, Bluesky, and YouTube posts or transcripts.
