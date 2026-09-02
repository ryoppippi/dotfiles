## Code Comments Policy

- Comments explain _why_, not _what_: [Write "why" in comments](https://jisou-programmer.beproud.jp/%E9%96%A2%E6%95%B0%E8%A8%AD%E8%A8%88/10-%E3%82%B3%E3%83%A1%E3%83%B3%E3%83%88%E3%81%AB%E3%81%AF%E3%80%8C%E3%81%AA%E3%81%9C%E3%80%8D%E3%82%92%E6%9B%B8%E3%81%8F.html)
- If you need a paragraph-long comment to justify why the workaround is OK, the code is wrong — fix the code. (from [Rewriting Bun in Rust](https://bun.com/blog/bun-in-rust))
- Never write change-log comments (`// changed from X to Y`, `// updated for feature Z`). That explanation belongs in the commit message.
- Do NOT remove existing comments that explain logic, behaviour, or intent, even if they seem obvious. Only remove comments that are outdated or factually wrong.
- Write JSDoc for exported functions, classes, types, and interfaces, with `@param`, `@returns`, and `@example` where appropriate.
- For non-trivial logic (algorithms, bitwise operations, state machines, multi-step transformations), add line-by-line comments so the reader does not have to reverse-engineer it. Skip comments only for truly self-explanatory code.
