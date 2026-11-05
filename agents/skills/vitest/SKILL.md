---
name: vitest
description: Vitest conventions for assertions, snapshots, and fixtures. Use when writing, reviewing, or fixing Vitest tests.
---

# Vitest Testing

Whether a test is worth writing is the `tdd` skill's call; this covers the
shape of Vitest tests. Each test should read as one behaviour, top to bottom,
without jumping to shared context.

## Setup

- Use Vitest APIs without imports only when runtime globals and their
  TypeScript declarations (`vitest/globals`) are configured; otherwise import
  what the file uses. See https://vitest.dev/config/globals.
- Use `vi.stubEnv()` with `unstubEnvs: true` or `vi.unstubAllEnvs()` cleanup
  rather than mutating `process.env`; avoid dynamic
  `import()` unless dynamic loading is the behaviour under test.
- Run the repository’s Vitest command with `--changed` during a cycle; see https://vitest.dev/api/test
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

Prefer JSON assertions for structured results. Do not write snapshot tests
(`toMatchSnapshot`, `toMatchInlineSnapshot`, `toMatchFileSnapshot`): nobody
reviews snapshot diffs, so they get regenerated rather than read and catch
nothing. For CLI or table output, assert the lines that matter with explicit
matchers, and fix the terminal width for responsive output.

The exception is a code generator whose output is the product: commit the
generated file with `toMatchFileSnapshot` in its real extension (`Output.swift`,
not `.snap`), so a PR reviews it as code, and check it with the target
toolchain (compile or type-check it) so the file is verified, not just recorded.
