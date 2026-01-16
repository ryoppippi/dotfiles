# Nix Build Rules

## Debug Flags

Use these flags only when debugging build errors:

```bash
--print-build-logs --show-trace
```

- `--print-build-logs`: Shows full build output (normally only shown on failure)
- `--show-trace`: Displays stack traces on evaluation errors

## Examples

```bash
# Normal usage (no flags needed)
nix build
nix run .#switch
nix flake check

# When debugging errors
nix build --print-build-logs --show-trace
nix flake check --print-build-logs --show-trace
```

## CI Usage

In CI environments, prefer `nix profile install` over `nix develop` for faster setup:

```bash
# Install specific tools from nixpkgs
nix profile install --inputs-from . nixpkgs#uv nixpkgs#just nixpkgs#ruff

# Or from the flake's packages
nix profile install .#my-package
```

This avoids the overhead of setting up a full dev shell in CI.
