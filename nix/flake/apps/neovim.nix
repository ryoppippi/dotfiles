{ constants, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    let
      homedir =
        if pkgs.stdenv.hostPlatform.isDarwin then constants.darwinHomedir else constants.linuxHomedir;

      bash = lib.getExe pkgs.bash;
      neovim = lib.getExe pkgs.neovim;
    in
    {
      apps = {
        nvim-restore = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "nvim-restore" ''
              : "''${DOTFILES_DIR:=${homedir}/ghq/github.com/ryoppippi/dotfiles}"
              if [ ! -d "$DOTFILES_DIR" ]; then
                DOTFILES_DIR="$(pwd)"
              fi
              exec ${bash} \
                ${../../modules/home/programs/neovim/check.sh} \
                "$DOTFILES_DIR/nvim" \
                "$HOME/.local/share/nvim/lazy" \
                ${neovim}
            ''
          );
        };

        # Regenerate the Nix-served lazy.nvim plugin sources from the
        # runtime plugin table and lazy-lock.json. Runs against the
        # working tree (not the store copy) because it writes the
        # generated files back into the repository.
        lazy2nix = {
          type = "app";
          program = toString (
            pkgs.writeShellScript "lazy2nix" ''
              set -e
              : "''${DOTFILES_DIR:=${homedir}/ghq/github.com/ryoppippi/dotfiles}"
              if [ ! -d "$DOTFILES_DIR" ]; then
                DOTFILES_DIR="$(pwd)"
              fi
              export PATH=${pkgs.bun}/bin:$PATH
              exec bun run "$DOTFILES_DIR/nix/modules/home/programs/neovim/lazy2nix/generate.ts"
            ''
          );
        };
      };
    };
}
