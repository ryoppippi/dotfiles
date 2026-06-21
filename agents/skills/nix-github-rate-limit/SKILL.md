---
name: nix-github-rate-limit
description: Prevents and handles GitHub API rate limits with gh-nix. Use when Nix, flakes, nixpkgs commands, or comma may fetch GitHub-backed inputs.
---

# Nix GitHub Rate Limit

Use this skill before running Nix commands that may fetch GitHub-backed flakes or packages, especially `nix flake update`, `nix run github:...`, `nix run nixpkgs#...`, `nix build`, `nix shell`, and comma.

## Default Approach

Use `gh-nix` to run commands that may cause Nix to fetch from GitHub. It reads the token from the authenticated GitHub CLI at runtime and supplies it through Nix's `access-tokens` setting without exposing the token in the command text:

```sh
gh-nix nix flake update
gh-nix nix run github:<owner>/<repo>
gh-nix nix run nixpkgs#<package> -- <args>
gh-nix nix build
gh-nix nix shell nixpkgs#<package> --command <command>
gh-nix , <command>
```

For this dotfiles repo:

```sh
gh-nix nix run .#build
gh-nix nix run .#switch
gh-nix nix run .#update
```

Do not write GitHub tokens to `nix.conf`, repository files, skill files, shell config, or command arguments.

## Fallback

If `gh-nix` is unavailable, prefer ephemeral token injection from GitHub CLI. Shell history records the literal command substitution rather than the expanded token:

```sh
NIX_CONFIG="access-tokens = github.com=$(gh auth token)" nix flake update
```

If `GITHUB_TOKEN` is already present in the environment, bridge it into Nix's documented `access-tokens` setting without exposing the token value in the command text:

```sh
NIX_CONFIG="access-tokens = github.com=$GITHUB_TOKEN" nix flake update
```

If `ghtkn` is configured and a short-lived GitHub App user token is preferred:

```sh
NIX_CONFIG="access-tokens = github.com=$(ghtkn get)" nix flake update
```

Do not create `GITHUB_TOKEN` by pasting a raw token into the terminal or an agent tool call.

## Workflow

1. If the command may cause Nix to fetch from GitHub, check whether `gh-nix` is available:

   ```sh
   command -v gh-nix
   ```

2. If available, prefix the original command with `gh-nix`. Preserve every argument exactly.
3. If `gh-nix` reports that `gh` is unauthenticated, ask the user to run `gh auth login`; do not attempt to capture or supply credentials.
4. If `gh-nix` is unavailable, use the safest fallback token source already present: `$GITHUB_TOKEN`, authenticated `gh`, or configured `ghtkn`.
5. If no safe token source is available, run the command normally unless the user explicitly wants to authenticate first.
6. If a GitHub API rate limit error appears, retry once with `gh-nix` or the safest available fallback.

## History Safety

- Follow the global command privacy rule: command text, shell history, process lists, terminal output, tool invocation logs, and coding-agent transcripts must not contain raw tokens.
- Prefer `gh-nix` because the command text contains neither the token nor token-producing command substitution.
- When falling back from `gh-nix`, prefer inline command substitution such as `$(gh auth token)` or `$(ghtkn get)` inside the command the user runs.
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
- `gh-nix` preserves existing `NIX_CONFIG` settings while prepending the GitHub access token configuration.
- `NIX_CONFIG` keeps the token out of the command arguments, but environment variables can still be visible to sufficiently privileged local processes. Prefer it only for short-lived commands.
- If `GITHUB_TOKEN` is already provided by CI or a controlled environment, Nix may use it, but do not create or persist it just for local interactive use.
