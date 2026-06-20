{ pkgs, ... }:
{
  home.packages = with pkgs.llm-agents; [
    cursor-agent
    grok
  ];
}
