{
  ai-tools,
  claude-code-overlay,
  system,
}: final: prev: {
  # AI tools overlay
  inherit
    (ai-tools.packages.${system})
    codex
    cursor-agent
    opencode
    copilot-cli
    coderabbit-cli
    ;

  # Claude Code overlay
  claude-code = claude-code-overlay.packages.${system}.default;
}
