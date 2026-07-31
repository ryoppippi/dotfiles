---
name: tdd
description: Guides execute-inspect-adjust development and t-wada Red-Green-Refactor TDD. Use for exploratory implementation or when stable behaviour needs an executable test-first contract.
---

Use TDD when a behaviour should become an executable contract. For unfamiliar APIs, prototypes, and data exploration, use execute-inspect-adjust first; not every probe needs a test.

## Cycle

1. Sketch behaviours as placeholder tests and choose one. Start bug fixes with a regression test.
2. **Red** — Write the smallest failing test and confirm the expected failure.
3. **Green** — Write the minimum production code that passes it.
4. **Refactor** — Improve test and production code while keeping tests green.
5. Run affected tests after each green and refactor step, then repeat.

Keep each test focused on one observable behaviour; do not weaken tests to make the build pass.

For runner-specific syntax, read the matching file in `references/`.
