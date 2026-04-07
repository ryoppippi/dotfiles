# Agent skills configuration for Claude Code
# https://github.com/Kyure-A/agent-skills-nix
#
# All skills (external and local) are managed here via agent-skills-nix.
# Skills are deployed to ~/.agents (standard location) and ~/.config/claude/skills
{
  pkgs,
  lib,
  ast-grep-skill,
  agent-browser-skill,
  local-skills,
  ...
}:
{
  programs.agent-skills = {
    enable = true;

    # Skill sources (from flake inputs)
    sources = {
      # External: ast-grep official skill
      ast-grep = {
        path = ast-grep-skill;
        subdir = "ast-grep/skills";
      };
      # External: agent-browser skill
      agent-browser = {
        path = agent-browser-skill;
        subdir = "skills";
      };
      # Local: skills from this dotfiles repo
      local = {
        path = local-skills;
        subdir = "agents/skills";
      };
    };

    # Enable all local skills
    skills.enableAll = [ "local" ];

    skills.explicit.ast-grep = {
      from = "ast-grep";
      path = "ast-grep";
      packages = [ pkgs.ast-grep ];
      transform =
        { original, dependencies }:
        let
          patched =
            builtins.replaceStrings
              [ "| ast-grep " "ast-grep scan " "ast-grep run " ]
              [ "| ./ast-grep " "./ast-grep scan " "./ast-grep run " ]
              original;
        in
        ''
          ${patched}

          ${dependencies}
        '';
    };

    skills.explicit.agent-browser =
      let
        agentBrowserBin = lib.getExe pkgs.llm-agents.agent-browser;
      in
      {
        from = "agent-browser";
        path = "agent-browser";
        packages = [ pkgs.llm-agents.agent-browser ];
        transform =
          { original, ... }:
          builtins.replaceStrings
            [
              "Bash(npx agent-browser:*), Bash(agent-browser:*)"
              "./agent-browser"
            ]
            [
              "Bash(${agentBrowserBin}:*)"
              agentBrowserBin
            ]
            original;
      };

    # Deploy to standard skills directories
    targets = {
      # Standard ~/.agents/skills directory
      agents = {
        dest = ".agents/skills";
        structure = "copy-tree";
      };
      # Claude Code user config
      claude = {
        dest = ".config/claude/skills";
        structure = "link";
      };
    };
  };
}
