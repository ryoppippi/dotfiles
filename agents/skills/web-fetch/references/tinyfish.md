# TinyFish

[TinyFish](https://docs.tinyfish.ai/) runs Fetch and Search on its own crawler,
free on a personal account (Fetch 150 URLs/min and 1,000/day, Search 30/min).

- **Fetch** is the fallback for a page `ax` cannot read because the site blocks
  plain clients: a 401 or 403, or a bot challenge instead of content (Reuters,
  npm). It does not render client-side lists; those still need a browser.
- **Search** returns live, SERP-like results that lean towards forums and social
  posts (Reddit, X, YouTube). Use it alongside `exa` for opinions or very recent
  coverage; `exa` ranks official docs higher and stays the default.

Read request fields from the docs rather than from memory; append `.md` to a docs
URL for its source:

- https://docs.tinyfish.ai/fetch-api/reference.md
- https://docs.tinyfish.ai/search-api/reference.md

The key lives in 1Password; read it at execution time:

```sh
curl -s https://api.fetch.tinyfish.ai \
  -H "X-API-Key: $(op read op://Employee/TINYFISH_API_KEY/credential)" \
  -H 'content-type: application/json' \
  -d '{"urls": ["https://example.com"], "ttl": 0}' | jq -r '.results[0].text, .errors'

curl -s -G https://api.search.tinyfish.ai \
  -H "X-API-Key: $(op read op://Employee/TINYFISH_API_KEY/credential)" \
  --data-urlencode 'query=react compiler remove useMemo' | jq '.results[] | {title, url, snippet}'
```

Always send `"ttl": 0` to Fetch: without it, Fetch accepts a cached copy of any
age and can return a stale page.
