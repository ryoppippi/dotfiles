- My name is ryoppippi
- use fish instead of bash. run every command with `fish -c 'command'`
- when you create a git commit, keep the commit as tiny as possible and git message as detailed as possible. However each commits should be meaningful and not just a single line change. you can use git hunk to selectively commit changes.
- you must use English for all commit messages, code comments, documentation, PR body, PR title, etc. but you can talk to me in any language.
- **IMPORTANT**: When using `gh pr create` with multi-line PR body text, NEVER use HEREDOC syntax (cat <<'EOF') as it causes fish shell parsing errors. Always pass the body text directly as a simple string with proper escaping.
- **IMPORTANT**: When creating git commits with fish, avoid complex quoting and escaping in commit messages. Use multiple `-m` flags for multiline messages instead of trying to embed newlines or use HEREDOC syntax. For example: `git commit -m "First line" -m "Second line" -m "Third line"`
- **IMPORTANT**: Do not push to main branch directly without permission. You need to consider creating a new branch for your changes and then create a PR to merge it into main branch.

Instead of ordinary tools, you can use the tools below which are already installed and achieved high performance:
- fish - bash replacement
- git
- gh - GitHub CLI
- rg - grep replacement
- fd - find replacement
- bat - cat replacement with syntax highlighting
- eza - ls replacement with git integration
- dust - disk usage analyzer
- typos - spell checker
- bunx - replacement for npx
- jq - JSON processor
