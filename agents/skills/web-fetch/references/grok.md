# grok

Search tweets when no URL is known — Grok has native X search:

```sh
grok -p "Search X for recent tweets about <topic>. Reply with tweet URLs and summaries."
```

Feed found URLs to `./tgrab` when full content is needed.
