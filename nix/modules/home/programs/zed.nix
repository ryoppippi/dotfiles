{
  pkgs,
  lib,
  config,
  ...
}:
let
  jsonFormat = pkgs.formats.json { };

  settings = {
    theme = "Kanagawa Wave";
    assistant = {
      default_model = {
        provider = "ollama";
        model = "codestral:22b-v0.1-q4_K_S";
      };
      version = "2";
    };
    ui_font_size = 16;
    buffer_font_size = 16;
    vim_mode = true;
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
in
{
  # Zed editor configuration (prettified)
  xdg.configFile."zed/settings.json".source = jsonFormat.generate "settings.json" settings;
}
