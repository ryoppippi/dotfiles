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
    model = "gpt-5.2-codex";
    approval_policy = "on-request";
    model_reasoning_effort = "medium";
    web_search_request = true;

    mcp_servers = {
      chrome-devtools = {
        command = bunx;
        enabled = false;
        args = [
          "chrome-devtools-mcp@latest"
        ];
      };

      context7 = {
        startup_timeout_ms = 5000;
        url = "https://mcp.context7.com/mcp";
      };

      deepwiki = {
        startup_timeout_ms = 5000;
        url = "https://mcp.deepwiki.com/mcp";
      };

      figma-dev-mode-mcp-server = {
        startup_timeout_ms = 5000;
        url = "http://127.0.0.1:3845/mcp";
      };
    };

    notice = {
      hide_gpt5_1_migration_prompt = true;
      "hide_gpt-5.1-codex-max_migration_prompt" = true;
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
