---
name: cross-model-review
description: When the user asks for a code review, or before opening a pull request.
---

# Cross-Model Review

A review by the model and harness that wrote the change catches little, so send
it to another vendor's model, another vendor's harness, or both.

Inside T3 Code, read [references/inside-t3.md](references/inside-t3.md);
otherwise read [references/outside-t3.md](references/outside-t3.md).

## Models

ryoppippi's picks, best first — follow them over any assumption about which
model is newest, and edit this list when the judgement changes. Each resolves
to the newest version, so never pin one.

- Codex: `astra`, then `sol`
- Claude: `opus`; `fable` only for a genuinely hard review

## Scope and brief

Ask when the scope is unclear: uncommitted changes (`git diff HEAD` plus
untracked files), a branch (`git diff <base>...HEAD`), or a commit
(`git show <sha>`). Brief the reviewer with that command:

```text
Review <selected scope command and any applicable untracked files>. Look for correctness bugs and for
fixes that treat a symptom instead of its cause. Do not edit files. Cite
file:line for every finding, and list critical findings separately from
suggestions.
```

## Reporting

Verify each finding against the code before acting on it. Report critical
findings separately from suggestions, with file and line, and say which harness
and model reviewed.
