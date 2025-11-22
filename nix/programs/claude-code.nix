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

  # Claude Code configuration files
  home.file = {
    "${claudeConfigDir}/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${claudeDotfilesDir}/settings.json";
    "${claudeConfigDir}/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink "${claudeDotfilesDir}/CLAUDE.md";
    "${claudeConfigDir}/commands".source = config.lib.file.mkOutOfStoreSymlink "${claudeDotfilesDir}/commands";
    "${claudeConfigDir}/agents".source = config.lib.file.mkOutOfStoreSymlink "${claudeDotfilesDir}/agents";
    "${claudeConfigDir}/output-styles".source = config.lib.file.mkOutOfStoreSymlink "${claudeDotfilesDir}/output-styles";
  };
}
