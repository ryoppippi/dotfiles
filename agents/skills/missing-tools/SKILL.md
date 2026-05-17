---
name: missing-tools
description: Resolves missing CLI tools. Use when a command is unavailable, a shell reports command not found, or a tool must be run without installing it globally.
---

# Missing Tools

Use this workflow when a command is unavailable in the current shell.

## Priority Order

1. Try the current project's direnv environment:

   ```sh
   direnv exec . <command>
   ```

2. Use [comma](https://github.com/nix-community/comma) for tools from nixpkgs:

   ```sh
   , <command>
   ```

3. Use `nix run` when a specific nixpkgs package is needed:

   ```sh
   nix run nixpkgs#<package> -- <args>
   ```

4. Use `nix shell` as the last resort:

   ```sh
   nix shell nixpkgs#<package> --command <command>
   ```

## Notes

- Never install missing tools globally. Do not use commands such as `npm install -g`, `npm i -g`, `pnpm add -g`, `yarn global add`, `bun add -g`, `uv tool install`, `brew install`, or language-specific global installers to resolve a missing command.
- Prefer `direnv exec .` first because project-local dev shells often already provide the right tool version and environment variables.
- Comma automatically finds and runs the nixpkgs package containing the requested command.
- Use fish for shell wrapping in this dotfiles environment:

  ```sh
  fish -c '<command>'
  ```
