{
  lib,
  omniwmModule,
  pkgs,
  config,
  ...
}:
let
  checkedNu =
    pkgs.runCommand "omniwm-trackpad-overview.nu" { nativeBuildInputs = [ pkgs.nushell ]; }
      ''
        export HOME="$TMPDIR"
        nu --no-config-file --commands "source ${./trackpad-overview.nu}"
        cp ${./trackpad-overview.nu} "$out"
      '';

  trackpadOverview = pkgs.writeShellApplication {
    name = "omniwm-trackpad-overview";
    runtimeInputs = [ pkgs.nushell ];
    text = ''
      exec nu ${checkedNu} \
        --karabiner-cli /opt/homebrew/bin/karabiner_cli \
        --omniwmctl /etc/profiles/per-user/${config.home.username}/bin/omniwmctl
    '';
  };
in
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

  launchd.agents.omniwm-trackpad-overview = {
    enable = true;
    config = {
      ProgramArguments = [ "${trackpadOverview}/bin/omniwm-trackpad-overview" ];
      ProcessType = "Interactive";
      RunAtLoad = true;
      KeepAlive = true;
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
