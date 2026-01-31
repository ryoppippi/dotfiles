{ pkgs, homedir, ... }:
let
  dotfilesDir = "${homedir}/ghq/github.com/ryoppippi/dotfiles";

  karabiner-driverkit = pkgs.fetchurl {
    url = "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v6.8.0/Karabiner-DriverKit-VirtualHIDDevice-6.8.0.pkg";
    hash = "sha256-tX6TIfn3XeC5Da7F9ai2e1AkmWE/sr5pBmO5+g5aqMI=";
  };
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

    # Create symlink to kanata in /Applications for Input Monitoring permission
    echo "Creating kanata symlink in /Applications..."
    ln -sf ${pkgs.kanata}/bin/kanata /Applications/kanata
  '';

  launchd.daemons.kanata = {
    serviceConfig = {
      Label = "com.github.jtroo.kanata";
      ProgramArguments = [
        "${pkgs.kanata}/bin/kanata"
        "--cfg"
        "${dotfilesDir}/kanata/kanata.kbd"
        "--port"
        "5829"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/var/log/kanata.out.log";
      StandardErrorPath = "/var/log/kanata.err.log";
    };
  };

  launchd.agents.kanata-vk-agent = {
    serviceConfig = {
      Label = "com.devsunb.kanata-vk-agent";
      ProgramArguments = [
        "${pkgs.kanata-vk-agent}/bin/kanata-vk-agent"
        "-p"
        "5829"
        "-b"
        "com.hnc.Discord,com.openai.chat"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/kanata-vk-agent.out.log";
      StandardErrorPath = "/tmp/kanata-vk-agent.err.log";
    };
  };
}
