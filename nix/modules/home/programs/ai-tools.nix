{ pkgs, ... }:
{
  home.packages = with pkgs.llm-agents; [
    cursor-agent
    opencode
    copilot-cli
    coderabbit-cli
    rtk
  ];
}
