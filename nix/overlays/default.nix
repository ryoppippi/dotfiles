final: prev:
let
  # Import all overlay files in this directory
  overlayFiles = [
    ./claude-code.nix
    # GitHub CLI extensions
    ./gh-user-stars.nix
    ./gh-triage.nix
    # Small Go/Rust CLI tools not in nixpkgs
    ./git-now.nix
    ./git-wtpr.nix
    ./roots.nix
    ./audio-priority-bar.nix
  ];

  # Apply each overlay and merge results
  applyOverlays = builtins.foldl' (acc: overlay: acc // (import overlay final prev)) { } overlayFiles;
in
applyOverlays
