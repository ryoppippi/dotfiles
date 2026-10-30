{
  pkgs,
  lib,
  config,
  dotfilesDir,
  helpers,
  ...
}:
let
  nvimDotfilesDir = "${dotfilesDir}/nvim";
  nvimConfigDir = "${config.xdg.configHome}/nvim";
in
{
  # Plugins are resolved from the lazy.nvim spec by `nvimx-lock` and pinned in
  # nvim/nvimx-lock/flake.lock; lazy.nvim only loads them from the Nix store.
  # See ROADMAP.md for why nvimx replaced lazy2nix.
  programs.nvimx = {
    enable = true;

    # The config is symlinked from the working tree below so edits apply
    # without a switch; nvimx only needs the lock.
    manageConfig = false;
    lockDir = ../../../../../nvim/nvimx-lock;
    # Only read by env.check, which CI builds
    configDir = ../../../../../nvim;

    lock = {
      projectDir = dotfilesDir;
      configDirRelative = "nvim";
      lockDirRelative = "nvim/nvimx-lock";
    };

    # Own plugins (`dev = true` in the spec) load from the mutable ghq checkout
    devPath = "~/ghq/github.com/ryoppippi";

    treesitter.grammars = "all";

    # These packages are only available when NeoVim is running
    extraPackages = with pkgs; [
      tree-sitter # CLI needed by nvim-treesitter to install grammars nixpkgs does not ship (e.g. moonbit)

      # Plugin runtime dependencies, so Neovim does not rely on the login shell's PATH
      gh # octo.nvim
      git # git-conflict.nvim and friends
    ];
  };

  # lazy.nvim used to clone itself here; nvimx links its locked copy to the
  # same path, and checkLinkTargets refuses to replace a real directory.
  home.activation.moveLegacyLazyNvim = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    legacy="${config.xdg.dataHome}/nvim/lazy/lazy.nvim"
    if [ -d "$legacy" ] && [ ! -L "$legacy" ]; then
      run mv "$legacy" "$legacy.pre-nvimx"
    fi
  '';

  # Create symlink to NeoVim configuration in dotfiles (bypassing Nix store)
  home.activation.linkNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${helpers.activation.mkLinkForce}
    link_force "${nvimDotfilesDir}" "${nvimConfigDir}"
  '';
}
