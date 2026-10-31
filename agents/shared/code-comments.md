## Code Comments

- Default to no comment. Write one only when a future reader, without the commit at hand, would misread the code or undo it by mistake — and then explain why, not what ([「なぜ」を書く](https://jisou-programmer.beproud.jp/%E9%96%A2%E6%95%B0%E8%A8%AD%E8%A8%88/10-%E3%82%B3%E3%83%A1%E3%83%B3%E3%83%88%E3%81%AB%E3%81%AF%E3%80%8C%E3%81%AA%E3%81%9C%E3%80%8D%E3%82%92%E6%9B%B8%E3%81%8F.html)).
- If a workaround needs a paragraph to justify it, the code is wrong — fix the code ([Rewriting Bun in Rust](https://bun.com/blog/bun-in-rust)).
- Change history and the reasons for config entries or small diffs belong in the commit message, not in comments.
- Keep existing comments that explain intent; remove only outdated or wrong ones.
- Explain non-obvious intent and invariants in complex logic; keep self-explanatory steps uncommented.
- Write JSDoc only for public API that other packages or users consume.
