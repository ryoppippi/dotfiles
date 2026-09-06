# Karabiner-Elements configuration, built from karabiner/karabiner.ts.
#
# The TypeScript config runs inside a bun2nix derivation: its npm dependencies
# come from karabiner/bun.nix rather than a node_modules checkout, and the
# generated karabiner.json lives in the store instead of being committed.
# Only karabiner.json is linked. Karabiner writes automatic_backups and
# assets next to it, so ~/.config/karabiner stays a plain writable directory.
{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config.xdg) configHome;
  grep = lib.getExe pkgs.gnugrep;

  karabinerDir = ../../../../../karabiner;

  karabinerConfig = pkgs.stdenv.mkDerivation {
    pname = "karabiner-config";
    version = "0-unstable";

    src = lib.fileset.toSource {
      root = karabinerDir;
      fileset = lib.fileset.unions [
        (karabinerDir + "/karabiner.ts")
        (karabinerDir + "/devices.ts")
        (karabinerDir + "/utils.ts")
        (karabinerDir + "/karabiner.base.json")
        (karabinerDir + "/package.json")
        (karabinerDir + "/bun.lock")
      ];
    };

    nativeBuildInputs = [ pkgs.bun2nix.hook ];

    bunDeps = pkgs.bun2nix.fetchBunDeps {
      bunNix = karabinerDir + "/bun.nix";
    };

    # The only lifecycle script is the root postinstall that regenerates
    # bun.nix, which is meaningless inside the sandbox.
    dontRunLifecycleScripts = true;
    # The hook's default phases build and install a compiled executable; this
    # package produces a JSON file instead.
    dontUseBunBuild = true;
    dontUseBunCheck = true;
    dontUseBunInstall = true;

    # karabiner.ts embeds this path into shell_command rules
    env.OMNIWMCTL = lib.getExe' config.programs.omniwm.package "omniwmctl";

    buildPhase = ''
      runHook preBuild
      # writeToProfile merges the rules into an existing file, so start from
      # the template that carries the profile, devices and simple modifications
      cp karabiner.base.json karabiner.json
      KARABINER_JSON="$PWD/karabiner.json" bun run karabiner.ts
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      install -Dm644 karabiner.json "$out/karabiner.json"
      runHook postInstall
    '';
  };
in
{
  # bun2nix regenerates karabiner/bun.nix from package.json's postinstall hook
  home.packages = [ pkgs.bun2nix ];

  xdg.configFile."karabiner/karabiner.json".source = "${karabinerConfig}/karabiner.json";

  home.activation.prepareKarabinerConfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    # ~/.config/karabiner used to be a symlink to the dotfiles checkout; a
    # linked directory would make home-manager write karabiner.json into the
    # repository instead of the config directory
    if [ -L "${configHome}/karabiner" ]; then
      $DRY_RUN_CMD rm "${configHome}/karabiner"
    fi

    # Restart Karabiner console user server before updating config to prevent keyboard freeze
    # The daemon can enter an inconsistent state if config changes while running
    if /bin/launchctl list | ${grep} -q "org.pqrs.service.agent.Karabiner-Console-User-Server"; then
      echo "Restarting Karabiner console user server before config update..."
      $DRY_RUN_CMD /bin/launchctl kickstart -k gui/$(/usr/bin/id -u)/org.pqrs.service.agent.Karabiner-Console-User-Server 2>/dev/null || true
      sleep 2
    fi
  '';
}
