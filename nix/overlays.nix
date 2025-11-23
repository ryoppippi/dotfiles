{
  ai-tools,
  claude-code-overlay,
  system,
}:
final: prev:
let
  # Import custom overlays (includes gh extensions and small Go CLI tools)
  customOverlays = import ./overlays/default.nix final prev;
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
// customOverlays # Custom overlays (gh extensions + small Go CLI tools)
// (claude-code-overlay.overlays.default final prev)
