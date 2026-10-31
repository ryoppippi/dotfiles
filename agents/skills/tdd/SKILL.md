---
name: tdd
description: When the user asks for TDD or a regression test, or a change has an obvious cheap test target in an existing suite.
---

# TDD

Use TDD when a behaviour should become an executable contract. For unfamiliar
APIs, prototypes, and data exploration, execute-inspect-adjust first; not every
probe needs a test.

No new test beats a bad test. Skip one that would need broad harness setup,
brittle mocks, slow end-to-end infrastructure, production-only state, or
unrelated fixture churn, or that would be deleted once it proved the fix. Verify
with the closest executable check instead: a targeted script, a reproduction
command, browser automation, or a focused existing test run.

Before writing a test, find the public interface and the seam where its
behaviour is observable. Where `CONTEXT.md` or ADRs exist, use their vocabulary.
For judging tests and anti-patterns, read
[references/testing.md](references/testing.md); for test doubles, read
[references/mocking.md](references/mocking.md). For Vitest, use the
`vitest-testing` skill.

## Cycle

1. Sketch behaviours as placeholder tests and pick one slice. For a bug, use the
   narrowest check already exercising that path; if there is none, reproduce it
   with a script rather than building a harness.
2. **Red** — write the smallest failing test and confirm it fails as expected.
3. **Green** — write the minimum code that passes it.
4. **Refactor** — improve test and code while staying green; run affected tests
   after each step, then repeat.

Work in vertical slices — one seam, one test, one minimal implementation — and
never weaken a test to make the build pass.

## Report

Report the evidence, not just the outcome: the check that failed before the
change and how, the run that passes after it, and nearby tests run. If no
failing-before evidence was possible, say why and name the closest check used.
