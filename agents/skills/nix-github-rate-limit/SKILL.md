---
name: nix-github-rate-limit
description: Prevents and handles GitHub API rate limits during Nix commands. Use when running nix flake, nix run, nix build, nix shell, or comma against GitHub-backed inputs.
---

# Nix GitHub Rate Limit

Use this skill before running Nix commands that may fetch GitHub-backed flakes or packages, especially `nix flake update`, `nix run github:...`, `nix run nixpkgs#...`, `nix build`, `nix shell`, and comma.

## Default Approach

Prefer ephemeral token injection from GitHub CLI. Do not write GitHub tokens to `nix.conf`, repository files, skill files, shell config, or command arguments.

Use command substitution inside `NIX_CONFIG` for a single command when `gh` is already authenticated. Shell history records the literal command substitution, not the expanded token:

```fish
env NIX_CONFIG="access-tokens = github.com=$(gh auth token)" nix flake update
```

If `ghtkn` is configured and a short-lived GitHub App user token is preferred:

```fish
env NIX_CONFIG="access-tokens = github.com=$(ghtkn get)" nix flake update
```

If `GITHUB_TOKEN` is already present in the environment, bridge it into Nix's documented `access-tokens` setting without exposing the token value in the command text:

```fish
env NIX_CONFIG="access-tokens = github.com=$GITHUB_TOKEN" nix flake update
```

Do not create `GITHUB_TOKEN` by pasting a raw token into the terminal or an agent tool call.

For this dotfiles repo:

```fish
env NIX_CONFIG="access-tokens = github.com=$(gh auth token)" nix run .#build
env NIX_CONFIG="access-tokens = github.com=$(gh auth token)" nix run .#switch
env NIX_CONFIG="access-tokens = github.com=$(gh auth token)" nix run .#update
```

For missing tool execution:

```fish
env NIX_CONFIG="access-tokens = github.com=$(gh auth token)" nix run nixpkgs#<package> -- <args>
env NIX_CONFIG="access-tokens = github.com=$(gh auth token)" nix shell nixpkgs#<package> --command <command>
```

## Workflow

1. If the command is a Nix command that may touch GitHub, check whether `gh` is available and authenticated:

   ```fish
   command -q gh; and gh auth status
   ```

2. If `GITHUB_TOKEN` is already set, run the Nix command with `NIX_CONFIG="access-tokens = github.com=$GITHUB_TOKEN"`.
3. If `gh` is authenticated, run the Nix command with `NIX_CONFIG="access-tokens = github.com=$(gh auth token)"`.
4. If `ghtkn` is configured and the user prefers short-lived GitHub App tokens, use `NIX_CONFIG="access-tokens = github.com=$(ghtkn get)"`.
5. If no safe token source is available, run the command normally unless the user explicitly wants to authenticate first.
6. If a GitHub API rate limit error appears, retry once with the safest available `NIX_CONFIG` wrapper.

## History Safety

- Follow the global command privacy rule: command text, shell history, process lists, terminal output, tool invocation logs, and coding-agent transcripts must not contain raw tokens.
- Prefer inline command substitution such as `$(gh auth token)` or `$(ghtkn get)` inside the command the user runs.
- It is also acceptable to reference an existing environment variable by name, such as `$GITHUB_TOKEN`; do not assign the raw value in the command.
- Do not paste a raw token into the terminal, even temporarily.
- Do not run commands like `env NIX_CONFIG="access-tokens = github.com=ghp_..." ...`.
- Do not place raw tokens in agent tool calls, command logs, or explanatory messages.
- Do not store a token in fish universal variables, exported shell variables, direnv files, or shell history cleanup scripts.
- If a raw token was accidentally pasted, tell the user to rotate or revoke it. Deleting shell history is not enough.

## Avoid

- Do not use `--access-tokens "github.com=$(gh auth token)"` because command arguments can be exposed via process listings.
- Do not store PATs in `~/.config/nix/nix.conf`, `/etc/nix/nix.conf`, repository files, or dotfiles by default.
- Do not suggest broad PAT scopes. Public GitHub fetches should not need additional repository permissions.
- Do not print tokens, echo tokens, or include them in logs, summaries, commits, PR descriptions, or issue comments.

## Notes

- Unauthenticated GitHub REST API requests are rate limited much more aggressively than authenticated requests.
- `NIX_CONFIG` keeps the token out of the command arguments, but environment variables can still be visible to sufficiently privileged local processes. Prefer it only for short-lived commands.
- If `GITHUB_TOKEN` is already provided by CI or a controlled environment, Nix may use it, but do not create or persist it just for local interactive use.
