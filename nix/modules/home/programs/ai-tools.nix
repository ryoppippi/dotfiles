{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # AI coding agents from nix-ai-tools
    # Note: codex is managed separately in codex.nix with custom wrapper
    # Note: amp is managed separately in amp.nix with custom wrapper
    cursor-agent
    opencode
    copilot-cli
    coderabbit-cli
  ];
}
