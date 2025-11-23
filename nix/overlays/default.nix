final: prev:
let
  # Import all overlay files in this directory
  overlayFiles = [
    # GitHub CLI extensions
    ./gh-do.nix
    ./gh-graph.nix
    ./gh-user-stars.nix
    ./gh-triage.nix
    # Small Go CLI tools not in nixpkgs
    ./sheep.nix
    ./gyazo-cli.nix
    ./oglens.nix
    ./tv.nix
  ];

  # Apply each overlay and merge results
  applyOverlays = builtins.foldl' (acc: overlay: acc // (import overlay final prev)) { } overlayFiles;
in
applyOverlays
