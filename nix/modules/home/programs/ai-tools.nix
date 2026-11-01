{ pkgs, ... }:
{
  home.packages = [
    pkgs.llm-agents.cursor-agent
    pkgs.llm-agents.grok
    pkgs.llm-agents.pi
    pkgs.t3-limits
  ];
}
