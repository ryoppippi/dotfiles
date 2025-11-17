- My name is ryoppippi
- when you create a git commit, use the git-commit-crafter skill. Keep the commit as tiny as possible and git message as detailed as possible. However each commits should be meaningful and not just a single line change. you can use git hunk to selectively commit changes.
- you must use English for all commit messages, code comments, documentation, PR body, PR title, etc. but you can talk to me in any language.
- **IMPORTANT**: Use UK English spelling as much as possible in all English text (e.g. "colour", "organise", "analyse", "behaviour", "honour", "initialise", "realise", "recognise", "specialise", "summarise", "utilise", etc.)
- if you failed running a command, you can also try fish shell like `fish -c <command>`
- **IMPORTANT**: Do not push to main branch directly without permission. You need to consider creating a new branch for your changes and then create a PR to merge it into main branch.
- if you failed running `bunx <command>`, you can try `bun x <command>` instead.

Instead of ordinary tools, you can use the tools below which are already installed and achieved high performance:
- fish - bash replacement
- git
- gh - GitHub CLI
- rg - grep replacement
- fd - find replacement
- bat - cat replacement with syntax highlighting
- eza - ls replacement with git integration
- dust - disk usage analyser
- typos - spell checker
- bunx - replacement for npx
- jq - JSON processor

Also, you may have codex mcp. codex is a ai agent. if you are stuck, you can ask codex for help.
Codex is:
- capable of writing code in multiple programming languages
- capable of analysing code and finding bugs
- capable of searching the web for information (really good)

**IMPORTANT**: When you need to analyze codebase structure or search for specific code patterns, use the ast-grep skill instead of ordinary grep/rg tools.

ast-grep provides:
- Structural code search using Abstract Syntax Tree (AST) patterns
- More accurate pattern matching than text-based search
- Language-aware code analysis with support for JavaScript/TypeScript, Python, Rust, Go, Java, C/C++, Ruby, PHP, and more
- Metavariables (`$VAR` syntax) for flexible pattern matching
- Contextual searching with logical combinations (AND, OR, NOT)

Use ast-grep skill when:
- Locating async functions lacking error handling
- Finding React components using specific hooks
- Identifying console.log calls within specific contexts
- Discovering functions exceeding parameter limits
- Searching for code patterns or language constructs
- Finding functions, classes, or specific structural elements
- Performing complex code queries beyond simple text matching
- Analyzing code structure and relationships

Best practices:
- Provide specific details and concrete examples when requesting searches
- Start broadly, then refine iteratively based on results
- Request rule explanations to understand the search approach
- If results don't match expectations, ask to display the generated rule or inspect AST structure
