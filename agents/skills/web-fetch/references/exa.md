# exa

Semantic search and LLM-ready extraction. Use bun + TypeScript with the `exa-js` SDK — the REST/cURL recipes floating around are stale (`livecrawl` and `type: "neural" | "keyword"` no longer exist).

Read the API surface from the docs rather than from memory. Append `.md` to any docs URL to get the source markdown, and grep the fetched file for the option you need — exact names matter here, so do not route these pages through a summarising web tool:

- https://exa.ai/docs/sdks/typescript-sdk-specification.md — full reference: every option and response field
- https://exa.ai/docs/sdks/javascript-sdk.md — quickstart with runnable examples
- https://exa.ai/docs/llms.txt — index of every docs page

The key lives in 1Password, so read it at execution time instead of exporting it:

```ts
const apiKey = (await Bun.$`op read op://keys/EXA_API_KEY/credential`.text()).trim();
const exa = new Exa(apiKey);
```

One asymmetry the reference page does not spell out: on `search` the `text` / `highlights` / `summary` options nest inside `contents`, but on `getContents` they are top-level.
