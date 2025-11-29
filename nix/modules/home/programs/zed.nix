{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.zed-editor = {
    enable = true;

    extensions = [
      "html"
      "toml"
      "sql"
      "svelte"
      "lua"
      "zig"
      "emmet"
      "kanagawa"
      "typst"
      "unocss"
    ];

    userSettings = {
      theme = "Kanagawa Wave";
      ui_font_size = 16;
      buffer_font_size = 16;
      vim_mode = true;

      assistant = {
        default_model = {
          provider = "ollama";
          model = "codestral:22b-v0.1-q4_K_S";
        };
        version = "2";
      };

      language_models = {
        ollama = {
          api_url = "http://localhost:11434";
          low_speed_timeout_in_seconds = 120;
          available_models = [
            {
              name = "qwen2.5-coder";
              display_name = "qwen 2.5 coder 32K";
              max_tokens = 32768;
            }
          ];
        };
      };
    };
  };
}
