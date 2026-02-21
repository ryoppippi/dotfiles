{
  pkgs,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/ghq/github.com/ryoppippi/dotfiles",
  ...
}:
let
  codexConfigDir = "${config.xdg.configHome}/codex";
  codexDotfilesDir = "${dotfilesDir}/codex";

  # TOML format generator
  tomlFormat = pkgs.formats.toml { };

  # Bun executable path from Nix
  bunx = "${pkgs.bun}/bin/bunx";

  # Codex configuration settings
  settings = {
    model = "gpt-5.3-codex-spark";
    approval_policy = "on-request";
    model_reasoning_effort = "high";
    web_search_request = true;
    project_doc_fallback_filenames = [ "CLAUDE.md" ];

    mcp_servers = {
      chrome-devtools = {
        command = bunx;
        enabled = false;
        args = [
          "chrome-devtools-mcp@latest"
        ];
      };
    };
  };
in
{
  home = {
    # Codex package
    packages = [ pkgs.codex ];

    # Set CODEX_HOME environment variable (sourced via hm-session-vars.sh)
    sessionVariables = {
      CODEX_HOME = codexConfigDir;
    };

    # Codex configuration files
    file = {
      # Generated config.toml from Nix settings
      "${codexConfigDir}/config.toml" = {
        source = tomlFormat.generate "codex-config" settings;
        force = true;
      };
      # Symlink AGENTS.md from dotfiles
      "${codexConfigDir}/AGENTS.md".source =
        config.lib.file.mkOutOfStoreSymlink "${codexDotfilesDir}/AGENTS.md";
    };
  };
}
