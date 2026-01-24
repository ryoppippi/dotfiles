final: prev:
let
  # Import all overlay files in this directory
  overlayFiles = [
    # AI tools
    ./ai-tools.nix
    ./claude-code.nix
    # GitHub CLI extensions
    ./gh-user-stars.nix
    ./gh-triage.nix
    # Small Go/Rust CLI tools not in nixpkgs
    ./sheep.nix
    ./git-now.nix
    ./bluetooth-connector.nix
    ./roots.nix
    ./git-wt.nix
  ];

  # Apply each overlay and merge results
  applyOverlays = builtins.foldl' (acc: overlay: acc // (import overlay final prev)) { } overlayFiles;
in
applyOverlays
