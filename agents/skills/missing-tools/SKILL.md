---
name: missing-tools
description: When a command is not found, or a tool must run without being installed globally.
---

Try, in order:

1. `, <command>` (comma). When several packages provide the command it runs the
   one named after it and says so on stderr; if that is wrong, list them with
   `, -p <command>` and use step 3.
2. `direnv exec . <command>` for the project environment.
3. `nix run nixpkgs#<package> -- <args>`, or
   `nix shell nixpkgs#<package> --command <command>` when it needs a shell.
4. Last resort: `docker run --rm -v "$PWD:/workspace" -w /workspace <image> <command>`.

A script whose interpreter is missing: read its shebang and run
`nix shell nixpkgs#<package> --command ./<script>`.

For Nix fetches from GitHub, use the `nix-github-rate-limit` skill. Never
install tools globally.
