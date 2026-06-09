{ pkgs, ... }:
{
  home.packages = with pkgs.llm-agents; [
    cursor-agent
    grok
    opencode
    copilot-cli
    coderabbit-cli
    rtk
  ];
}
