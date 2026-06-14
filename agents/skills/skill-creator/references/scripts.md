# Scripts

Pre-written scripts under `scripts/` are the right tool when an operation is deterministic and repeated. They are **executed**, not loaded — only the script's stdout enters the context, so a 300-line script costs the same as a 5-line one for the agent.

Use a script when:

- The operation has many fragile flags or pipe stages that the agent could get subtly wrong.
- The same logic is needed across many invocations of the skill.
- You want a stable, testable artifact (lint, validate, format, deploy).
- The output is structured (JSON, a patch, a count) and the agent should consume it, not regenerate it.

Skip a script when the work is one or two ordinary shell commands or when each invocation needs different logic; just document the commands in `SKILL.md`.

Layout:

```text
agents/skills/example-skill/
├── SKILL.md
├── references/
│   └── api.md
└── scripts/
    ├── validate.sh
    └── analyse.py
```

Rules:

- Make execution intent explicit in `SKILL.md`: write `Run scripts/validate.sh` (execute) vs `See scripts/validate.sh for the algorithm` (read as reference). Default to execute.
- Mark scripts executable (`chmod +x`) and use a real shebang (`#!/usr/bin/env bash` / `#!/usr/bin/env python3`).
- Handle errors inside the script instead of punting back to the agent. Print a precise, actionable message (`Field 'foo' missing. Available: bar, baz.`) so the agent can fix the input and retry.
- No magic constants — justify timeouts, retry counts, and thresholds in a comment.
- Use forward slashes in every documented path. They work on every platform.
