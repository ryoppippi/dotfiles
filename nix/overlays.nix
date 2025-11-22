{
  ai-tools,
  claude-code-overlay,
  system,
}: final: prev:
  {
    # AI tools overlay (excluding claude-code which comes from claude-code-overlay)
    inherit
      (ai-tools.packages.${system})
      codex
      cursor-agent
      opencode
      copilot-cli
      coderabbit-cli
      ;
  }
  // (claude-code-overlay.overlays.default final prev)
