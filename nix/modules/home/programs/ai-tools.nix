{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # AI coding agents from nix-ai-tools
    # Note: codex is managed separately in codex.nix with custom wrapper
    amp
    cursor-agent
    opencode
    copilot-cli
    coderabbit-cli
  ];
}
