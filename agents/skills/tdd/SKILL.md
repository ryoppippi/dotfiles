---
name: tdd
description: Guides execute-inspect-adjust development and t-wada Red-Green-Refactor TDD. Use when the user asks for TDD, a failing test or a regression test, or when a change has an obvious cheap test target in an existing suite. Skip when the test path is unclear, expensive, integration-heavy or not asked for.
---

Use TDD when a behaviour should become an executable contract. For unfamiliar APIs, prototypes, and data exploration, use execute-inspect-adjust first; not every probe needs a test.

Prefer no new test over a bad test. Do not force one when it would need broad harness setup, brittle mocks, slow end-to-end infrastructure, production-only state or unrelated fixture churn, or when it would be deleted as soon as it had proved the fix. Verify with the closest executable check instead: a targeted script, a reproduction command, browser automation or a focused existing test run.

Before writing a test, identify the public interface and the seam where its behaviour can be observed. When `CONTEXT.md` or relevant ADRs exist, read them so test names and interfaces use the project's vocabulary.

For test design and anti-patterns, read [`references/testing.md`](references/testing.md). For test doubles and system boundaries, read [`references/mocking.md`](references/mocking.md).

## Cycle

1. Sketch behaviours as placeholder tests, identify their public seams, and choose one slice. For a bug, pick the narrowest check already used for that code path; if none is obvious, do not build one from scratch, reproduce it with a script instead.
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

## Report

Report the evidence, not just the outcome: the check that failed before the change and how it failed, the run that passes after it, and any nearby tests run. If no failing-before evidence could be shown, say why and name the closest check used instead.
