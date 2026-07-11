{ pkgs, lib, ... }:
let
  # Check if we're on a platform that supports certain packages
  inherit (pkgs.stdenv) isLinux;
  isX86Linux = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
in
{
  home.packages =
    with pkgs;
    [
      # Essentials
      curl
      fish
      tmux
      # VCS
      bit
      git
      git-now
      git-wt
      git-wtpr
      git-lfs
      ghq
      # Security
      tirith
      # Code review TUI
      tuicr
      # Search & file utilities
      ripgrep
      fd
      fzf
      zoxide
      bat
      eza
      jq
      dust
      delta
      vivid
      trash-cli
      # Development languages & package managers
      devenv
      nodejs_24
      bun
      deno
      pnpm
      uv
      # Miscellaneous utilities
      fixjson
      gifski
      roots

    ]
    ++ lib.optionals isLinux [
      audacity
    ]
    # Platform-specific GUI applications
    ++ lib.optionals isX86Linux [
      telegram-desktop
    ];
}
