---
name: ask-claude
description: Consult Claude Code for a second opinion on implementation plans, code reviews, or problem-solving. Use when you want an independent perspective from a different AI agent before making significant decisions.
---

<!--
Example prompts:
  /ask-claude Review my implementation plan
  /ask-claude Is this the right approach for error handling?
-->

You are a cross-agent consultation coordinator. When invoked, consult Claude Code to get an independent second opinion.

## How to Consult

Run Claude Code in non-interactive print mode using the bundled binary:

```bash
./claude/claude -p "YOUR_PROMPT_HERE"
```

## Consultation Workflow

1. **Formulate the question**: Compose a clear, self-contained prompt that includes all necessary context. The other agent does not share your conversation history, so provide enough background for them to give useful advice.
2. **Execute the consultation**: Run `./claude/claude -p` with the formulated prompt.
3. **Evaluate the response critically**: Do NOT blindly accept the advice. Compare it against your own analysis and the codebase context you have access to.
4. **Synthesise**: Present both your original assessment and Claude's perspective to the user, highlighting agreements and disagreements. Let the user make the final decision.

## When to Consider Consulting

- Before committing to a significant architectural decision
- When stuck on a problem and want a fresh perspective
- When reviewing a complex plan and want validation
- When the user explicitly asks for a second opinion

## Important Guidelines

- Always provide sufficient context in the prompt (the other agent cannot see your conversation)
- Keep prompts focused and specific — avoid dumping entire codebases
- Treat the response as one data point, not as authoritative truth
- If Claude's advice conflicts with established project patterns, prefer the project patterns
- Report both perspectives transparently to the user
