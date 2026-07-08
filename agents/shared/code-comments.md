## Code Comments Policy

- Before writing or reviewing code comments, read [Write "why" in comments](https://jisou-programmer.beproud.jp/%E9%96%A2%E6%95%B0%E8%A8%AD%E8%A8%88/10-%E3%82%B3%E3%83%A1%E3%83%B3%E3%83%88%E3%81%AB%E3%81%AF%E3%80%8C%E3%81%AA%E3%81%9C%E3%80%8D%E3%82%92%E6%9B%B8%E3%81%8F.html)
- If you need a paragraph-long comment to justify why the workaround is OK, the code is wrong — fix the code. (from [Rewriting Bun in Rust](https://bun.com/blog/bun-in-rust))

### Forbidden

- Do NOT add comments explaining what was changed or why a change was made
- Comments like `// changed from X to Y` or `// updated for feature Z` are forbidden
- If a change needs explanation, write it in the git commit message instead
- Git commits should contain detailed explanations of what changed and why
- Do NOT remove existing comments that explain logic, behaviour, or intent — even if they seem obvious to you. Only remove comments that are clearly outdated or factually wrong.

### Required

- **JSDoc**: Always write JSDoc comments for exported functions, classes, types, and interfaces. Include `@param`, `@returns`, and `@example` where appropriate.
- **Complex logic**: When a function or block contains non-trivial logic (algorithms, bitwise operations, state machines, multi-step transformations, etc.), add line-by-line comments explaining what each step does and why. The reader should be able to follow the logic without having to reverse-engineer it.
- Only skip comments for code that is truly self-explanatory (simple getters, one-liner utilities, etc.).
