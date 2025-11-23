# Codex Global Instructions

## Python Execution

When executing Python scripts, always use `uv` instead of `python` directly:

```bash
# Use uv to run Python scripts
uv run script.py

# Or for inline execution
uv run python -c "print('hello')"
```

This ensures consistent Python environment management without requiring global Python installations.

## Available Tools

The following tools are preferred and available globally:

- **Search**: Use `rg` (ripgrep) instead of grep
- **Find**: Use `fd` instead of find
- **JSON**: Use `jq` for JSON processing
- **Shell**: Fish shell is the primary shell
