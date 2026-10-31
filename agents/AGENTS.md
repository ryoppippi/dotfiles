# Global Agent Instructions

The single global instruction file, shared by every agent. Claude Code reads it
as `~/.config/claude/CLAUDE.md` and resolves the `@` imports; Codex gets the
`shared/` fragments concatenated in at switch time.

## About Me

- My name is ryoppippi
- I prefer UK English spelling in all English text
- You can talk to me in any language, but all code-related output (commits, comments, docs, PRs) must be in English

## How to Work

- Fix root causes. Understand why a problem happens before changing code, check whether the same class of problem exists elsewhere, and fix the shared mechanism once instead of each symptom.
- Nearby code is not a template. If it carries a band-aid, don't copy it; propose the design fix.
- An urge to add a retry, special-case an error, loosen a type or test, or patch one call site is a signal that a symptom may be hiding a cause. Find the cause first; if a workaround is still right, say why.
- These instructions state intent, not a checklist. When following a rule to the letter would defeat its purpose, follow the purpose and say so.
- Commit messages and PR descriptions explain the root cause and why this fix.

@~/.config/claude/shared/tools.md

@~/.config/claude/shared/nix.md

@~/.config/claude/shared/code-comments.md

@~/.config/claude/shared/command-privacy.md

@~/.config/claude/shared/git.md

@~/.config/claude/shared/delegate-work.md
