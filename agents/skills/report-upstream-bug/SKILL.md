---
name: report-upstream-bug
description: When a bug lies in someone else's open-source tool and needs a minimal reproduction or an upstream issue.
---

# Report an Upstream Bug

What maintainers need from a reproduction: https://antfu.me/posts/why-reproductions-are-required
— the problem and nothing else, every dependency declared, no global tools,
expected versus actual, and a link back to the issue. A failing test in the
upstream repository beats a separate repro repository.

## Flow

1. **Confirm it is the tool.** Run the same code against the baseline (the
   official plugin, the previous version) and keep that run — a 200 against a
   500 is the issue's first line. Check the latest release first.
2. **Read upstream first.** Search for duplicates
   (`gh search issues --repo <owner>/<repo> "<symptom>"`), read the contributing
   guide and issue templates, and clone with `ghq get -s` when the cause is
   worth finding.
3. **Reduce.** Copy the failing file into a scratch directory outside any repo,
   stub its imports, and delete until one thing is left; drop framework layers
   when a plain build reproduces it.
4. **Compare.** Put baseline and tool behind one config switch (baseline by
   default, a short env var such as `RSVELTE=1` for the tool), with scripts
   `repro` / `repro:official` and a `show` pair printing each one's output. The
   diff of those outputs is the evidence. If the baseline fails too, the
   harness is wrong, not the tool.
5. **Find the likely cause** in upstream source. Write it as a hypothesis, name
   the file and commit read, and say it was not patched and rebuilt.
6. **Publish the repro, then the issue** — [references/templates.md](references/templates.md).

## Facts and constraints

- Repos go in the `ryoppippi-bug-repro` org (not `ryoppippi-repro`): one public,
  MIT-licensed repo per bug, named after the symptom. Generate the licence with
  `gh repo license view mit` (author: the user's GitHub name, current year).
- Creating the repo and filing the issue are public posts: do them when asked,
  otherwise show the draft first. Never name or link a private repository.
- Pin exact versions of the tool, baseline, runtime, and `packageManager` (pnpm),
  and record them in the README. Clean-install and run both scripts before
  pushing, and claim only what that run showed.
- Keep the issue's commands identical to the repro's script names.
- Afterwards, disable issues and projects with `gh repo edit`, and set
  `pull_request_creation_policy=collaborators_only` with `gh api -X PATCH`
  (pull requests cannot be switched off through the API; tell the user the
  Settings checkbox removes the tab). Re-read the issue with `gh issue view`
  after any edit.
