{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # AI coding agents from llm-agents.nix
    # Note: codex is managed separately in codex.nix with custom wrapper
    # Note: amp is managed separately in amp.nix with custom wrapper
    cursor-agent
    opencode
    copilot-cli
    coderabbit-cli
  ];
}
