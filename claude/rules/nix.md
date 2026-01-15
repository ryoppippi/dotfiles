# Nix Build Rules

## Build Flags

Always use these flags when running Nix build commands:

```bash
--print-build-logs --show-trace
```

## Examples

```bash
# Building
nix build --print-build-logs --show-trace

# Running apps
nix run .#switch -- --print-build-logs --show-trace
nix run .#build -- --print-build-logs --show-trace

# Flake check
nix flake check --print-build-logs --show-trace
```

## Rationale

- `--print-build-logs`: Shows full build output for debugging
- `--show-trace`: Displays stack traces on evaluation errors
