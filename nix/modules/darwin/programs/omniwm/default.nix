{
  lib,
  omniwmModule,
  ...
}:
{
  imports = [ omniwmModule ];

  programs.omniwm = {
    enable = true;
    settings = { };
    launchd = {
      enable = true;
      keepAlive = true;
    };
  };

  home.activation.writeOmniWMSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings_path="$HOME/.config/omniwm/settings.toml"
    temporary_settings_path="$settings_path.nix-tmp"

    mkdir -p "$HOME/.config/omniwm"
    cp ${./settings.toml} "$temporary_settings_path"
    chmod 644 "$temporary_settings_path"
    mv -f "$temporary_settings_path" "$settings_path"
  '';
}
