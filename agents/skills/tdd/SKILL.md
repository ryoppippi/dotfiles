---
name: tdd
description: Guides execute-inspect-adjust development and t-wada Red-Green-Refactor TDD. Use for exploratory implementation or when stable behaviour needs an executable test-first contract.
---

Use TDD when a behaviour should become an executable contract. For unfamiliar APIs, prototypes, and data exploration, use execute-inspect-adjust first; not every probe needs a test.

Before writing a test, identify the public interface and the seam where its behaviour can be observed. When `CONTEXT.md` or relevant ADRs exist, read them so test names and interfaces use the project's vocabulary.

For test design and anti-patterns, read [`references/testing.md`](references/testing.md). For test doubles and system boundaries, read [`references/mocking.md`](references/mocking.md).

## Cycle

1. Sketch behaviours as placeholder tests, identify their public seams, and choose one slice. Start bug fixes with a regression test.
2. **Red** — Write the smallest failing test and confirm the expected failure.
3. **Green** — Write the minimum production code that passes it.
4. **Refactor** — Improve test and production code while keeping tests green.
5. Run affected tests after each green and refactor step, then repeat.

Keep each test focused on one observable behaviour; do not weaken tests to make the build pass.

## Rules

- Test through a public interface at an agreed seam, not through private methods or implementation details.
- Work in vertical slices: one seam, one test, and one minimal implementation at a time. Do not write all tests first and all production code afterwards.
- Avoid implementation-coupled and tautological tests; expected values should come from an independent source of truth.
- Mock only system boundaries. For HTTP APIs, prefer request-level interception such as MSW over mocking `fetch`, an API client, or an internal module.

For runner-specific syntax, read the matching file in `references/`.
