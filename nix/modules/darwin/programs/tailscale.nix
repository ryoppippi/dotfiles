{ config, ... }:
{
  # Tailscale.app runs its own tailscaled, built with extra version tags. The
  # nixpkgs CLI has a plain version string, so every command warns about a
  # version mismatch; the CLI bundled with the app always matches the daemon.
  home.file.".local/bin/tailscale".source =
    config.lib.file.mkOutOfStoreSymlink "/Applications/Tailscale.app/Contents/MacOS/Tailscale";
}
