# Nix Build Rules

- Add `--print-build-logs --show-trace` only when debugging a failing build or evaluation; leave them off otherwise.
- In CI, prefer `nix profile install --inputs-from . nixpkgs#<tool>` (or `.#<package>`) over `nix develop` — a full dev shell is slow to set up.
- Keep a simple flake dependency-free: plain `outputs` needs no framework. Once per-system boilerplate becomes unwieldy, reach for `flake-parts` modules — never `flake-utils`.
