{ pkgs, ... }:
{
  home.packages = with pkgs.llm-agents; [
    cursor-agent
    gork
    opencode
    copilot-cli
    coderabbit-cli
    rtk
  ];
}
