{ pkgs, lib, ... }:
let
  # Check if we're on a platform that supports certain packages
  inherit (pkgs.stdenv) isDarwin isLinux;
  isX86Linux = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
in
{
  home.packages =
    with pkgs;
    [
      # Essentials
      curl
      htop
      fish
      tmux
      # VCS
      bit
      git
      git-now
      git-wt
      git-lfs
      ghq
      lazygit
      # Search & file utilities
      ripgrep
      fd
      fzf
      zoxide
      bat
      eza
      wezterm
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
      sheep
      roots

      # GUI applications (cross-platform)
      audacity
      vscode
    ]
    # Platform-specific GUI applications
    # discord only supports x86_64-linux, x86_64-darwin, aarch64-darwin (not aarch64-linux)
    ++ lib.optionals (isDarwin || isX86Linux) [
      discord
      telegram-desktop
    ];
}
