---
name: review-loop
description: Reviews a change with another vendor's model in a loop until it approves. Use when the user asks for a review or code review, says 'sol loop', or before opening a pull request.
---

# Review Loop

Adapted from [t3dotgg/tstack](https://github.com/t3dotgg/tstack) `sol-loop`
(MIT, see `LICENSE`).

A review by the model and harness that wrote the change catches little, so
send it to another vendor's model and loop until it approves. Make the most
minimal changes that answer the reviewer. Watch for scope creep and push back
when a finding is wrong.

## Reviewer

ryoppippi's picks, best first. Follow them over any assumption about which
model is newest, and edit this list when the judgement changes. Each resolves
to the newest version, so never pin one.

- From Claude: Codex `sol`, then `astra`
- From Codex: Claude `opus`; `fable` only for a genuinely hard review

If the user names a model ("sol loop" means Codex `sol`), use it. Inside T3
Code, start each round as in [references/inside-t3.md](references/inside-t3.md);
otherwise as in [references/outside-t3.md](references/outside-t3.md). If no
route reaches the model, report the blocker; do not substitute one.

## Budget

- Default: 3 rounds. Round 1 is full; later rounds check only changed code
  and open findings.
- Extend to 5 only for security, permissions, auth, data loss, or
  state/concurrency while a blocker or should stays open with evidence, or
  when the user asks.
- Stop early if a round returns only nits. Declined nits and comment, doc, or
  format-only fixes need no new round.
- One reviewer only. The reviewer must not start subagents or reviewers.
- Keep a ledger: id, severity, outcome. Never guess it.

## 1. Scope

Run `git status --short`. Do not stash, discard, or include unrelated changes.
Limit the review to the change's paths if they separate cleanly; otherwise ask.

Find the base after `git fetch origin`:

- PR: `gh pr view <n> --json baseRefName,headRefOid`. Confirm `HEAD` is the PR
  head, or ahead only by this change. Base:
  `git merge-base HEAD origin/<baseRefName>`.
- Local: `git merge-base HEAD origin/<default-branch>`. No remote: a base the
  user names, or `HEAD` for uncommitted changes only.

The change is base to working tree in those paths, with untracked files. Use
one diff command for every round. State the intent and what is out of scope in
1-2 sentences. Run the covering checks; do not send code this change breaks,
and note missing or already failing checks in the brief.

## 2. Brief

Do not edit scoped files while a review runs. Wait for its result; timeout,
error, or no reply is not approval.

Round 1 brief (a delegated reviewer gets no history):

```
Review only. Do not edit, commit, push, comment on PRs, or start subagents.
Repo: <abs path> Base: <sha> Intent: <intent> Out of scope: <scope> Checks: <results>
See: git diff <base> [-- <paths>]; git status --short (read untracked).
Read surrounding code. Find bugs, broken callers, fixes that treat a symptom
instead of its cause, and mismatch with intent. Skip style unless it hides a
bug. Hold to the smallest change. Flag code, tests, or guards the intent does
not need. Other paths, rare cases, small perf, extra compat: nits.
blocker = intended case wrong. should = real bug callers will hit, in intent. nit = rest.
Reply:
VERDICT: APPROVE or CHANGES
S1 [blocker|should|nit] <file>:<line> <claim>. Fix: <suggestion> (stable ids)
```

## 3. Answer findings

Check each finding and its severity yourself. Another path, a rare case, or a
small cost is a nit, whatever label it came with.

- Agree: the smallest fix. Prefer deleting or narrowing over a new lock, cache,
  helper, or option. Add one focused test that fails without the fix, if the
  intent needs it.
- Disagree: say why, with evidence (file:line, test, output).
- Out of scope or nit: decline in one line and list it as a follow-up.

Update the ledger, re-run the checks and `git diff --shortstat <base>`. If the
review grew the diff, cut first. Do not agree just to end the loop.

## 4. Next round

Start one only if budget remains and a blocker or should is open, behaviour
code changed, or the approval does not cover the current diff. Send the round 1
brief, the ledger (`fixed:` / `disagree:` / `declined:` with evidence), the same
base diff, and the change since the last round. Ask only about open ids and
changed code, marking each old id `resolved` or `still open: <reason>`.

## 5. Stop

- Agreed: APPROVE on the current diff, no blocker or should open, and no
  concern of your own.
- Stuck: an item stays disputed after two replies, or the budget ends. Show
  both sides in 2-3 lines each; the user decides. Budget end is not approval.

Do not push during the loop. Push afterwards only if the user asked to push,
ship, or update the PR. When the work ends in a PR, add
`Reviewed with review-loop: <N> rounds with <model>. Verdict: <verdict>.` to
its description.

Report: rounds, model, what the review changed, diff size before and after,
fixed and declined findings with reasons, and whether you pushed.
