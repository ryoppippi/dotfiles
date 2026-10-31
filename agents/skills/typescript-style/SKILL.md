---
name: typescript-style
description: When writing or reviewing TypeScript or TSX, including test fixtures, mocks, and config objects.
---

# TypeScript Style

Let the compiler check values instead of asserting their types.

- Use `satisfies` rather than `as` for object literals, mocks, config, fixtures,
  and expected rows; never `as any`.
- Use `as const satisfies` for static literal data where exact literals or
  readonly tuples help catch mistakes.
- Keep `as` for what `satisfies` cannot express — untyped external data, an API
  demanding a nominal type — and keep it local.
- Use `@ts-expect-error <reason>`, never `@ts-ignore`, so the suppression fails
  once the error is gone.

```ts
const config = { port: 3000, host: 'localhost' } satisfies ServerConfig;

const reportCases = [
	{ type: 'daily', period: '2026-05-16' },
	{ type: 'monthly', period: '2026-05' },
] as const satisfies readonly ReportCase[];

// @ts-expect-error Private runtime API has no public type declaration.
import privateApi from 'some-package/private-api';
```
