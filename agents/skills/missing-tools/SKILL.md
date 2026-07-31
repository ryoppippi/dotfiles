---
name: missing-tools
description: Resolves missing CLI tools. Use when a command is unavailable, a shell reports command not found, or a tool must be run without installing it globally.
---

Use this workflow when a required command is unavailable:

1. For scripts, read the shebang and run with its Nix package:

   ```sh
   nix shell nixpkgs#<package> --command ./<script>
   ```

2. Try the project environment: `direnv exec . <command>`.
3. Use `nix run nixpkgs#<package> -- <args>` when a package is known.
4. Use `nix shell nixpkgs#<package> --command <command>` when a package is known but a temporary shell is required.
5. `docker run --rm -v "$PWD:/workspace" -w /workspace <image> <command>`

For GitHub-backed Nix fetches, use the `nix-github-rate-limit` skill.

Never install tools globally. Use Zsh for normal commands; if a user tool is only on Fish's PATH, resolve it with `fish -lc 'command -v <tool>'` and invoke the resulting path.
