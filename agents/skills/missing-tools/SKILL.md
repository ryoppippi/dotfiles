---
name: missing-tools
description: Resolves missing CLI tools. Use when a command is unavailable, a shell reports command not found, or a tool must be run without installing it globally.
---

# Missing Tools

Use this workflow when a command is unavailable in the current shell.

## Priority Order

1. When running a script with a shebang, prioritise `nix shell` with the package that provides its interpreter before the usual order:

   ```sh
   nix shell nixpkgs#<package> --command ./<script>
   ```

   Read the shebang to select the interpreter package. This ensures the script runs with its declared runtime rather than an unrelated command found on `PATH`.

2. Try the current project's direnv environment:

   ```sh
   direnv exec . <command>
   ```

3. Use [comma](https://github.com/nix-community/comma) for tools from nixpkgs:

   ```sh
   , <command>
   ```

   When comma may fetch from GitHub, also use the `nix-github-rate-limit` skill.

4. Use `nix run` when a specific nixpkgs package is needed:

   ```sh
   nix run nixpkgs#<package> -- <args>
   ```

   When the command may fetch from GitHub, also use the `nix-github-rate-limit` skill.

5. Use `nix shell` as the last resort:

   ```sh
   nix shell nixpkgs#<package> --command <command>
   ```

   When the command may fetch from GitHub, also use the `nix-github-rate-limit` skill.

## Notes

- Never install missing tools globally. Do not use commands such as `npm install -g`, `npm i -g`, `pnpm add -g`, `yarn global add`, `bun add -g`, `uv tool install`, `brew install`, or language-specific global installers to resolve a missing command.
- Prefer `direnv exec .` first because project-local dev shells often already provide the right tool version and environment variables.
- Comma automatically finds and runs the nixpkgs package containing the requested command.
- Use a Zsh login shell for normal agent commands because the dotfiles-managed Zsh environment loads direnv without requiring Fish syntax:

  ```sh
  zsh -lc '<simple command>'
  ```

- Some user tools are only on Fish's PATH. If Zsh cannot find a command, resolve its absolute path through Fish and invoke that path from Zsh:

  ```sh
  fish -lc 'command -v <tool>'
  ```

- Use `fish -lc '<simple command>'` directly only when the command has no shell-specific syntax. Use Bash explicitly for Bash-specific syntax or a script with the appropriate shebang for complex commands.
