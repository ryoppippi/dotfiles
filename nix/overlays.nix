{
  ai-tools,
  claude-code-overlay,
  system,
}:
final: prev:
let
  # Import custom gh extensions overlay
  ghExtensionsOverlay = import ./overlays/default.nix final prev;
in
{
  # AI tools overlay (excluding claude-code which comes from claude-code-overlay)
  inherit (ai-tools.packages.${system})
    codex
    cursor-agent
    opencode
    copilot-cli
    coderabbit-cli
    ;
}
// ghExtensionsOverlay # Custom gh extensions
// (claude-code-overlay.overlays.default final prev)
