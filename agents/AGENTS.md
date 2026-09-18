# Global Agent Instructions

The single global instruction file, shared by every agent. Claude Code reads it
as `~/.config/claude/CLAUDE.md` — user-scope memory is only read under that
name — and Codex, which has no import mechanism, gets it with the `shared/`
fragments concatenated in at switch time.

## About Me

- My name is ryoppippi
- I prefer UK English spelling in all English text
- You can talk to me in any language, but all code-related output (commits, comments, docs, PRs) must be in English

@~/.config/claude/shared/tools.md

@~/.config/claude/shared/nix.md

@~/.config/claude/shared/code-comments.md

@~/.config/claude/shared/command-privacy.md

@~/.config/claude/shared/git-staging.md

@~/.config/claude/shared/git-worktrees.md

@~/.config/claude/shared/delegate-work.md

@~/.config/claude/shared/browser.md
