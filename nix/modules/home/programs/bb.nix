{
  pkgs,
  lib,
  config,
  ...
}:
let
  jq = lib.getExe pkgs.jq;
  caddy = lib.getExe pkgs.caddy;
  tailscale = "${config.home.homeDirectory}/.local/bin/tailscale";

  bbPort = 38886;
  gatePort = 38890;
  # Every device allowed to reach bb remotely (iPad, phones, the Grok bot) is
  # signed in as this tailnet user.
  allowedLogin = "ryo@rork.com";
  appUrl = "https://ryoppippi-rork-m5.tailee8c69.ts.net";

  telemetryEnv = {
    BB_TELEMETRY = "false";
  };

  # bb has no authentication on its API, websocket or MCP: anything that can
  # reach the port can run commands. It stays on loopback, and Tailscale
  # Serve reaches it only through this gate, which admits requests whose
  # Tailscale-User-Login (set by Serve from the peer's identity) is ours.
  gateConfig = pkgs.writeText "bb-gate.Caddyfile" ''
    {
      admin off
      auto_https off
      persist_config off
    }

    http://127.0.0.1:${toString gatePort} {
      bind 127.0.0.1
      @owner header Tailscale-User-Login ${allowedLogin}
      handle @owner {
        reverse_proxy 127.0.0.1:${toString bbPort}
      }
      respond "Forbidden" 403
    }
  '';
in
{
  home.sessionVariables = telemetryEnv;

  # Apps launched from the Dock do not inherit shell session variables.
  launchd.agents.bb-env = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        (lib.concatStringsSep "; " (
          lib.mapAttrsToList (name: value: "/bin/launchctl setenv ${name} ${value}") telemetryEnv
        ))
      ];
      RunAtLoad = true;
    };
  };

  launchd.agents.bb-gate = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        caddy
        "run"
        "--adapter"
        "caddyfile"
        "--config"
        "${gateConfig}"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardErrorPath = "${config.xdg.stateHome}/bb-gate.log";
    };
  };

  # Serve config lives in tailscaled, so re-applying it on login is idempotent.
  launchd.agents.bb-tailscale-serve = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        tailscale
        "serve"
        "--bg"
        "--https=443"
        "http://127.0.0.1:${toString gatePort}"
      ];
      RunAtLoad = true;
    };
  };

  # BB_APP_URL lets bb's Host and Origin checks accept the tailnet name. bb
  # rewrites config.json itself, so the key is merged in.
  home.activation.configureBbAppUrl = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
    lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      BB_DIR="$HOME/.bb"
      CONFIG="$BB_DIR/config.json"
      mkdir -p "$BB_DIR"
      if [ -f "$CONFIG" ]; then
        MERGED="$(${jq} --arg url '${appUrl}' '.BB_APP_URL = $url' "$CONFIG")"
      else
        MERGED="$(${jq} -n --arg url '${appUrl}' '{BB_APP_URL: $url}')"
      fi
      TEMP_FILE="$(mktemp "$BB_DIR/.config.json.XXXXXX")"
      printf '%s\n' "$MERGED" > "$TEMP_FILE"
      chmod 600 "$TEMP_FILE"
      mv "$TEMP_FILE" "$CONFIG"
    ''
  );
}
