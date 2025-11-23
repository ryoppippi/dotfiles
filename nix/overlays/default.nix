final: prev:
let
  # Import all overlay files in this directory
  overlayFiles = [
    ./gh-do.nix
    ./gh-graph.nix
    ./gh-user-stars.nix
    ./gh-triage.nix
  ];

  # Apply each overlay and merge results
  applyOverlays = builtins.foldl' (acc: overlay: acc // (import overlay final prev)) { } overlayFiles;
in
applyOverlays
