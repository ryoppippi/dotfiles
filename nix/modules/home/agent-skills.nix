# Agent skills configuration for Claude Code
# https://github.com/Kyure-A/agent-skills-nix
#
# All skills (external and local) are managed here via agent-skills-nix.
# Skills are deployed to ~/.agents (standard location) and ~/.config/claude/skills
{
  pkgs,
  config,
  lib,
  ast-grep-skill,
  agent-browser-skill,
  tgrab-skill,
  cmux-skill,
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
      # External: tgrab skill
      tgrab = {
        path = tgrab-skill;
        subdir = "skills";
      };
      cmux = {
        path = cmux-skill;
        subdir = "skills";
      };
      # Local: skills from this dotfiles repo
      local = {
        path = local-skills;
        subdir = "agents/skills";
      };
    };

    skills.enableAll = [ "local" ];

    skills.explicit.ast-grep =
      let
        astGrepBin = lib.getExe pkgs.ast-grep;
      in
      {
        from = "ast-grep";
        path = "ast-grep";
        packages = [ pkgs.ast-grep ];
        # Opt out of auto command rewriting: this skill rewrites bare names to
        # absolute Nix store paths via transform below, not to ./name. Leaving
        # rewriteCommands on would mangle the frontmatter name and prose, and
        # double-prefix command paths (.//nix/store/...).
        rewriteCommands = false;
        transform =
          { original, dependencies }:
          let
            patched =
              builtins.replaceStrings
                [ "| ast-grep " "ast-grep scan " "ast-grep run " ]
                [ "| ${astGrepBin} " "${astGrepBin} scan " "${astGrepBin} run " ]
                original;
          in
          ''
            ${patched}

            ${dependencies}
          '';
      };

    skills.explicit.tgrab = {
      from = "tgrab";
      path = "tgrab";
    };

    skills.explicit.cmux = {
      from = "cmux";
      path = "cmux";
    };

    skills.explicit.cmux-workspace = {
      from = "cmux";
      path = "cmux-workspace";
    };

    skills.explicit.cmux-settings = {
      from = "cmux";
      path = "cmux-settings";
    };

    skills.explicit.cmux-customization = {
      from = "cmux";
      path = "cmux-customization";
    };

    skills.explicit.cmux-diagnostics = {
      from = "cmux";
      path = "cmux-diagnostics";
    };

    skills.explicit.cmux-browser = {
      from = "cmux";
      path = "cmux-browser";
    };

    skills.explicit.cmux-markdown = {
      from = "cmux";
      path = "cmux-markdown";
    };

    skills.explicit.agent-browser =
      let
        agentBrowserBin = "${config.home.homeDirectory}/.agents/skills/agent-browser/agent-browser";
      in
      {
        from = "agent-browser";
        path = "agent-browser";
        packages = [ pkgs.llm-agents.agent-browser ];
        # Opt out of auto command rewriting: this skill rewrites bare names to
        # an absolute path under ~/.agents via transform below, not to ./name.
        rewriteCommands = false;
        transform =
          { original, ... }:
          builtins.replaceStrings
            [
              "Bash(agent-browser:*), Bash(npx agent-browser:*)"
              "Install: `npm i -g agent-browser && agent-browser install`\n\n"
              "agent-browser skills "
              "`agent-browser`"
            ]
            [
              "Bash(${agentBrowserBin}:*)"
              ""
              "${agentBrowserBin} skills "
              "`${agentBrowserBin}`"
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
