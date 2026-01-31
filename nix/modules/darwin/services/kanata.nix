{ pkgs, homedir, ... }:
let
  dotfilesDir = "${homedir}/ghq/github.com/ryoppippi/dotfiles";

  karabiner-driverkit = pkgs.fetchurl {
    url = "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v6.8.0/Karabiner-DriverKit-VirtualHIDDevice-6.8.0.pkg";
    hash = "sha256-tX6TIfn3XeC5Da7F9ai2e1AkmWE/sr5pBmO5+g5aqMI=";
  };

  kanataPath = "/Applications/kanata";
  kanataVkAgentPath = "/Applications/kanata-vk-agent";
  kanataConfigDir = "${dotfilesDir}/kanata";

  # Service labels
  kanataMacbookLabel = "com.github.jtroo.kanata.macbook";
  kanataClaw44Label = "com.github.jtroo.kanata.claw44";
  kanataVkAgentMacbookLabel = "com.devsunb.kanata-vk-agent.macbook";
  kanataVkAgentClaw44Label = "com.devsunb.kanata-vk-agent.claw44";
in
{
  system.activationScripts.postActivation.text = ''
    # Install Karabiner-DriverKit-VirtualHIDDevice if not already installed
    if ! /usr/sbin/pkgutil --pkg-info org.pqrs.Karabiner-DriverKit-VirtualHIDDevice >/dev/null 2>&1; then
      echo "Installing Karabiner-DriverKit-VirtualHIDDevice..."
      /usr/sbin/installer -pkg ${karabiner-driverkit} -target /
    fi

    # Activate the driver if not already active
    if [ -e "/Applications/.Karabiner-VirtualHIDDevice-Manager.app" ]; then
      echo "Activating Karabiner-VirtualHIDDevice driver..."
      /Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate 2>/dev/null || true
    fi

    # Create symlinks in /Applications for permission management
    echo "Creating kanata symlink in /Applications..."
    ln -sf ${pkgs.kanata}/bin/kanata ${kanataPath}
    echo "Creating kanata-vk-agent symlink in /Applications..."
    ln -sf ${pkgs.kanata-vk-agent}/bin/kanata-vk-agent ${kanataVkAgentPath}

    # Bootstrap and restart kanata services
    echo "Starting kanata services..."

    # Bootstrap if not loaded
    /bin/launchctl bootstrap system /Library/LaunchDaemons/${kanataMacbookLabel}.plist 2>/dev/null || true
    /bin/launchctl bootstrap system /Library/LaunchDaemons/${kanataClaw44Label}.plist 2>/dev/null || true
    /bin/launchctl bootstrap system /Library/LaunchAgents/${kanataVkAgentMacbookLabel}.plist 2>/dev/null || true
    /bin/launchctl bootstrap system /Library/LaunchAgents/${kanataVkAgentClaw44Label}.plist 2>/dev/null || true

    # Restart in correct order (MacBook first, then CLAW44 to prevent device conflicts)
    sleep 1
    /bin/launchctl kickstart -k system/${kanataClaw44Label} 2>/dev/null || true
    sleep 1
    /bin/launchctl kickstart -k system/${kanataMacbookLabel} 2>/dev/null || true
    sleep 1
    /bin/launchctl kickstart -k system/${kanataClaw44Label} 2>/dev/null || true
    /bin/launchctl kickstart -k system/${kanataVkAgentMacbookLabel} 2>/dev/null || true
    /bin/launchctl kickstart -k system/${kanataVkAgentClaw44Label} 2>/dev/null || true
  '';

  # MacBook internal keyboard
  launchd.daemons.kanata-macbook = {
    serviceConfig = {
      Label = kanataMacbookLabel;
      ProgramArguments = [
        kanataPath
        "--cfg"
        "${kanataConfigDir}/macbook.kbd"
        "--port"
        "5829"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/var/log/kanata-macbook.out.log";
      StandardErrorPath = "/var/log/kanata-macbook.err.log";
    };
  };

  # CLAW44 external keyboard
  launchd.daemons.kanata-claw44 = {
    serviceConfig = {
      Label = kanataClaw44Label;
      ProgramArguments = [
        kanataPath
        "--cfg"
        "${kanataConfigDir}/claw44.kbd"
        "--port"
        "5830"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/var/log/kanata-claw44.out.log";
      StandardErrorPath = "/var/log/kanata-claw44.err.log";
    };
  };

  # Virtual key agent for MacBook keyboard
  launchd.agents.kanata-vk-agent-macbook = {
    serviceConfig = {
      Label = kanataVkAgentMacbookLabel;
      ProgramArguments = [
        kanataVkAgentPath
        "-p"
        "5829"
        "-b"
        "com.hnc.Discord,com.openai.chat"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/kanata-vk-agent-macbook.out.log";
      StandardErrorPath = "/tmp/kanata-vk-agent-macbook.err.log";
    };
  };

  # Virtual key agent for CLAW44 keyboard
  launchd.agents.kanata-vk-agent-claw44 = {
    serviceConfig = {
      Label = kanataVkAgentClaw44Label;
      ProgramArguments = [
        kanataVkAgentPath
        "-p"
        "5830"
        "-b"
        "com.hnc.Discord,com.openai.chat"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/kanata-vk-agent-claw44.out.log";
      StandardErrorPath = "/tmp/kanata-vk-agent-claw44.err.log";
    };
  };
}
