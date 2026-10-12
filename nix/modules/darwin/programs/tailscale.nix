{
  # Tailscale.app runs its own tailscaled, built with extra version tags. The
  # nixpkgs CLI has a plain version string, so every command warns about a
  # version mismatch; the CLI bundled with the app always matches the daemon.
  # A wrapper rather than a symlink: invoked through a symlink, the binary
  # resolves an unknown bundle identifier and aborts.
  home.file.".local/bin/tailscale" = {
    executable = true;
    text = ''
      #!/bin/sh
      exec /Applications/Tailscale.app/Contents/MacOS/Tailscale "$@"
    '';
  };
}
