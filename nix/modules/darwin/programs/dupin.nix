{ pkgs, ... }:
{
  xdg.configFile."dupin/config.toml" = {
    source = (pkgs.formats.toml { }).generate "dupin-config.toml" {
      hotkey = "ctrl+space";
    };
    force = true;
  };
}
