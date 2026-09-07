# Overlaid nixpkgs instance shared by `perSystem` and the host configurations.
# Kept as a plain function instead of a flake module because the darwin and
# Home Manager configurations need it outside of `perSystem`.
{ inputs, system }:
let
  inherit (inputs)
    nixpkgs
    llm-agents
    nix-claude-code
    nix-bun
    bun2nix
    gh-nippou
    brew-nix
    omniwm
    ;

  isDarwin = builtins.match ".*-darwin" system != null;
in
import nixpkgs {
  inherit system;
  config.allowUnfree = true;
  overlays = [
    llm-agents.overlays.shared-nixpkgs
    (_final: _prev: {
      _nix-claude-code = nix-claude-code;
    })
    nix-bun.overlays.default
    bun2nix.overlays.default
    gh-nippou.overlays.default
    (import ./overlays/default.nix)
  ]
  ++ nixpkgs.lib.optionals isDarwin [
    brew-nix.overlays.default
    omniwm.overlays.additions
  ];
}
