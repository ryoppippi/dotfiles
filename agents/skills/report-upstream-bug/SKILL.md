---
name: report-upstream-bug
description: Reduces a bug found in someone else's open-source tool to a minimal reproduction in the ryoppippi-bug-repro org and files the upstream issue. Use when a dependency misbehaves, a drop-in swap breaks an app, or the user asks for a repro or an issue.
---

# Report an upstream bug

Why a reproduction is the thing maintainers need, and what a good one looks like:
https://antfu.me/posts/why-reproductions-are-required

Follow it: demonstrate the problem and nothing but the problem, declare every dependency in
`package.json`, need no global tools, say expected and actual, and link back to the issue.
A failing test in the upstream repo is better still; a repro repository is the fallback.

## Flow

1. **Confirm it is the tool.** Run the same app or component against the baseline (the official
   plugin, the previous version) and keep that run: a 200 against a 500 is the first line of the
   issue. Check the latest release before blaming an old one.
2. **Read upstream before writing.** `gh search issues --repo <owner>/<repo> "<symptom>"` for
   duplicates, then the repo's contributing guide and issue templates. Clone it with `ghq get -s`
   when the cause is worth finding (see the `ghq` rules in the global tools notes).
3. **Reduce.** Start from the failing real file in a scratch directory outside any repo, stub its
   imports, and delete until one thing is left. Drop the framework layers (SvelteKit, Next) when
   a plain build tool plus the renderer reproduces it.
4. **Compare.** Put the baseline and the tool behind one switch in the config, with the baseline
   as the default and a short environment variable for the tool under test (`RSVELTE=1`).
   Name the scripts `repro` (the tool) and `repro:official` (the baseline), and add a `show`
   pair that prints the generated output of each. The diff of those two outputs is the evidence.
5. **Check the harness first.** If the baseline also fails, the repro is wrong, not the tool
   (async flags, dev versus production compile, missing imports). Fix that before going on.
6. **Find the likely cause** by reading upstream source around the symptom. Write it as a
   hypothesis, and say you did not patch and rebuild. Name the file and commit you read.
7. **Publish the repro, then the issue.** See [references/templates.md](references/templates.md).
8. **Tidy the repro repo**: issues off, pull requests restricted to collaborators.

## Rules

- The org is `ryoppippi-bug-repro` (not `ryoppippi-repro`). One repo per bug, named after the
  symptom, public, MIT-licensed. Check with `gh api users/ryoppippi-bug-repro` if unsure.
- Creating the repo and filing the issue are public posts. Do them when asked; otherwise show
  the draft first.
- Never link or name a private repository in either. Describe the app generically.
- Clean-install the repro (`rm -rf node_modules`, frozen lockfile) and run both scripts before
  pushing. Only claim what that run showed.
- Pin exact versions of the tool, the baseline and the runtime; record them in the README.
- Pin `packageManager`; use the one the user's projects use (pnpm).
- The author line is the user's GitHub name; the licence year is the current year.
  Generate the text with `gh repo license view mit`, which has `[year]` and `[fullname]` to fill.
- Disable issues and projects with `gh repo edit`. Pull requests cannot be switched off through
  the API; set `pull_request_creation_policy=collaborators_only` with `gh api -X PATCH` and tell
  the user the Settings checkbox removes the tab.
- After editing a published issue, re-read it with `gh issue view`.
- Keep the issue's reproduction commands identical to the script names in the repro, so a later
  README edit never makes the issue wrong.
