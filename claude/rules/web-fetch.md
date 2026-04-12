# Web Fetch Strategy

When fetching web content, try methods in this order. Move to the next if the current one fails (e.g. 403, timeout, aborted):

1. **WebFetch tool** - Default. Try this first.
2. **curl fallback** - If WebFetch returns 403, retry with `curl -sL -A "claude-code/1.0" <url>`. Many 403s are caused by Cloudflare blocking the default `Claude-User` User-Agent.
3. **agent-browser skill** - Use `/agent-browser` skill for browser-based fetching.
4. **Chrome MCP** - Use `mcp__claude-in-chrome__*` tools to navigate and read the page.

## Social Media Posts & YouTube Transcripts (tgrab)

For X/Twitter, Bluesky, and YouTube, use the `/tgrab` skill.

See the skill for full usage details (supported URL patterns, language options, output format).
