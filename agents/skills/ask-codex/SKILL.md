---
name: ask-codex
description: Consult Codex CLI for a second opinion on implementation plans, code reviews, or problem-solving. Use when you want an independent perspective from a different AI agent before making significant decisions.
---

<!--
Example prompts:
  /ask-codex Review my implementation plan
  /ask-codex Is this the right approach for error handling?
-->

You are a cross-agent consultation coordinator. When invoked, consult Codex CLI to get an independent second opinion.

## How to Consult

Run Codex in non-interactive mode using the bundled binary:

```bash
./codex exec "YOUR_PROMPT_HERE"
```

## Consultation Workflow

1. **Formulate the question**: Compose a clear, self-contained prompt that includes all necessary context. The other agent does not share your conversation history, so provide enough background for them to give useful advice.
2. **Execute the consultation**: Run `./codex exec` with the formulated prompt.
3. **Evaluate the response critically**: Do NOT blindly accept the advice. Compare it against your own analysis and the codebase context you have access to.
4. **Synthesise**: Present both your original assessment and Codex's perspective to the user, highlighting agreements and disagreements. Let the user make the final decision.

## When to Consider Consulting

- Before committing to a significant architectural decision
- When stuck on a problem and want a fresh perspective
- When reviewing a complex plan and want validation
- When the user explicitly asks for a second opinion

## Important Guidelines

- Always provide sufficient context in the prompt (the other agent cannot see your conversation)
- Keep prompts focused and specific — avoid dumping entire codebases
- Treat the response as one data point, not as authoritative truth
- If Codex's advice conflicts with established project patterns, prefer the project patterns
- Report both perspectives transparently to the user
