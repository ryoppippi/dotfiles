---
name: nix-github-rate-limit
description: When a Nix or comma command may fetch from GitHub, or fails on a GitHub rate limit.
---

Prefix the command with `gh-nix`; it reads the token from the authenticated
`gh` without putting it in the command:

```sh
gh-nix nix flake update
gh-nix nix run .#switch
gh-nix nix run nixpkgs#<package> -- <args>
gh-nix , <command>
```

If `command -v gh-nix` finds nothing, pass a token from an existing source at
execution time:

```sh
NIX_CONFIG="access-tokens = github.com=$(gh auth token)" nix <command>
```

`$GITHUB_TOKEN` and `$(ghtkn get)` work the same way. If `gh` is not
authenticated, ask the user to run `gh auth login`.
