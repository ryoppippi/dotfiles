# Web Fetch Strategy

When fetching web content, try methods in this order. Move to the next if the current one fails (e.g. 403, timeout, aborted):

1. **WebFetch tool** - Default. Try this first.
2. **curl fallback** - If WebFetch returns 403, retry with `curl -sL -A "claude-code/1.0" <url>`. Many 403s are caused by Cloudflare blocking the default `Claude-User` User-Agent.
3. **agent-browser skill** - Use `/agent-browser` skill for browser-based fetching.
4. **Chrome MCP** - Use `mcp__claude-in-chrome__*` tools to navigate and read the page.

## Social Media Posts & YouTube Transcripts (tgrab)

For X/Twitter, Bluesky, and YouTube, use [tgrab](https://github.com/ryoppippi/tgrab):

```sh
nix run github:ryoppippi/tgrab -- <url>
```

| Service            | Example                                                                   |
| ------------------ | ------------------------------------------------------------------------- |
| YouTube transcript | `nix run github:ryoppippi/tgrab -- https://www.youtube.com/watch?v=...`   |
| Twitter / X post   | `nix run github:ryoppippi/tgrab -- https://x.com/user/status/...`         |
| Bluesky post       | `nix run github:ryoppippi/tgrab -- https://bsky.app/profile/.../post/...` |

**Important**: Always fetch via a subagent to keep the main conversation clean.
