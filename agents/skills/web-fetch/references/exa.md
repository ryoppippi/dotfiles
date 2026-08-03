# exa

Semantic search and LLM-ready extraction. Use bun + TypeScript with the `exa-js` SDK — the REST/cURL recipes floating around are stale (`livecrawl` and `type: "neural" | "keyword"` no longer exist).

Read the API surface from the docs rather than from memory:

- https://exa.ai/docs/sdks/typescript-sdk-specification — full reference: every option and response field
- https://exa.ai/docs/sdks/javascript-sdk — quickstart with runnable examples

The key lives in 1Password, so read it at execution time instead of exporting it:

```ts
const apiKey = (await Bun.$`op read op://keys/EXA_API_KEY/credential`.text()).trim();
const exa = new Exa(apiKey);
```

One asymmetry the reference page does not spell out: on `search` the `text` / `highlights` / `summary` options nest inside `contents`, but on `getContents` they are top-level.
