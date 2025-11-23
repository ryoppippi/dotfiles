{
  pkgs,
  lib,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/ghq/github.com/ryoppippi/dotfiles",
  claude-code-overlay,
  system,
  ...
}: let
  claudeConfigDir = "${config.xdg.configHome}/claude";
  claudeDotfilesDir = "${dotfilesDir}/claude";
  helpers = import ../lib/activation-helpers.nix {inherit lib;};

  # Get claude-code directly from overlay
  base-claude-code = (claude-code-overlay.overlays.default pkgs pkgs).claude-code;

  # Wrap Claude Code with CLAUDE_CONFIG_DIR environment variable
  claude-code-wrapped = pkgs.symlinkJoin {
    name = "claude-code-wrapped";
    paths = [base-claude-code];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/claude \
        --set CLAUDE_CONFIG_DIR ${claudeConfigDir}
    '';
  };
in {
  # Claude Code package with CLAUDE_CONFIG_DIR wrapper
  home.packages = lib.mkAfter [claude-code-wrapped];

  # Create direct symlinks to Claude Code configuration files (bypassing Nix store)
  home.activation.linkClaudeCodeConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${helpers.mkLinkForce}
    $DRY_RUN_CMD mkdir -p "${claudeConfigDir}"
    link_force "${claudeDotfilesDir}/settings.json" "${claudeConfigDir}/settings.json"
    link_force "${claudeDotfilesDir}/CLAUDE.md" "${claudeConfigDir}/CLAUDE.md"
    link_force "${claudeDotfilesDir}/commands" "${claudeConfigDir}/commands"
    link_force "${claudeDotfilesDir}/agents" "${claudeConfigDir}/agents"
    link_force "${claudeDotfilesDir}/output-styles" "${claudeConfigDir}/output-styles"
  '';
}
