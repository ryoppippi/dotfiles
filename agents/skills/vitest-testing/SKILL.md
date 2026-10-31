---
name: vitest-testing
description: When writing, reviewing, or fixing Vitest tests.
---

# Vitest Testing

Whether a test is worth writing is the `tdd` skill's call; this covers the
shape of Vitest tests. Each test should read as one behaviour, top to bottom,
without jumping to shared context.

## Setup

- Check `vitest.config.*` for `globals`: when enabled, use `describe`, `it`,
  `expect`, `vi`, and `assert` without importing; otherwise import only what the
  file uses.
- Use `vi.stubEnv()` rather than mutating `process.env`; avoid dynamic
  `import()` unless dynamic loading is the behaviour under test.
- Run `pnpm vitest --changed` during a cycle; see https://vitest.dev/api/test
  for modifiers (`it.todo`, `it.fails`, `it.each`, …).

## Readability

- One behaviour per `it`, named for what a caller observes.
- Expected failures use `expect(...).toThrow()` / `.rejects`, not `try`/`catch`.
- No `if` in test bodies: split the test, or use `it.each` when cases share one
  behaviour.
- KISS over DRY: repeat setup and write concrete values inline when that reads
  better. Helpers are for genuinely noisy fixtures, and assertions stay in the
  test.
- Narrow nullable values with `assert` instead of non-null assertions.

```ts
it('returns the first row', () => {
	const firstRow = getRows()[0];
	assert.isDefined(firstRow, 'expected at least one row');

	expect(firstRow.id).toBe('row-1');
});
```

## Output

Prefer JSON assertions for structured results. Use `toMatchFileSnapshot` for
human-readable CLI or table output so layout changes are reviewable, and fix the
terminal width for responsive output.
