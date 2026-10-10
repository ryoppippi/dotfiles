{ pkgs, ... }:
{
  home.packages = with pkgs.llm-agents; [
    cursor-agent
    grok
    t3code
  ];
}
