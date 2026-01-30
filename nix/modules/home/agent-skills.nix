# Agent skills configuration for Claude Code
# https://github.com/Kyure-A/agent-skills-nix
#
# All skills (external and local) are managed here via agent-skills-nix.
{
  pkgs,
  ast-grep-skill,
  local-skills,
  ...
}:
let
  # Relative path from home directory to XDG config
  # agent-skills dest is relative to $HOME
  xdgConfigRel = ".config";
in
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
      # Local: skills from this dotfiles repo
      local = {
        path = local-skills;
        subdir = ".";
      };
    };

    # Enable all local skills
    skills.enableAll = [ "local" ];

    # Explicit skill with package dependency
    skills.explicit.ast-grep = {
      from = "ast-grep";
      path = "ast-grep";
      packages = [ pkgs.ast-grep ];
    };

    # Deploy to skills directories
    targets = {
      claude = {
        dest = "${xdgConfigRel}/claude/skills";
        structure = "link";
      };
      codex = {
        dest = "${xdgConfigRel}/codex/skills";
        structure = "link";
      };
    };
  };
}
