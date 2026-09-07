{ constants, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      writeNu,
      ...
    }:
    let
      homedir =
        if pkgs.stdenv.hostPlatform.isDarwin then constants.darwinHomedir else constants.linuxHomedir;

      bash = lib.getExe pkgs.bash;
      bun = lib.getExe pkgs.bun;
      neovim = lib.getExe pkgs.neovim;

      # Both apps write into the repository, so they need the working tree, not
      # the store copy of it.
      resolveDotfiles = ''
        def dotfiles-dir [] {
          let configured = $env | get --optional DOTFILES_DIR | default "${homedir}/ghq/github.com/ryoppippi/dotfiles"
          if ($configured | path type) == "dir" { $configured } else { pwd }
        }
      '';
    in
    {
      apps = {
        nvim-restore = {
          type = "app";
          program = toString (
            writeNu "nvim-restore" ''
              ${resolveDotfiles}

              def main [] {
                exec ${bash} ${../../modules/home/programs/neovim/check.sh} (
                  dotfiles-dir | path join "nvim"
                ) ($env.HOME | path join ".local/share/nvim/lazy") ${neovim}
              }
            ''
          );
        };

        # Regenerate the Nix-served lazy.nvim plugin sources from the
        # runtime plugin table and lazy-lock.json.
        lazy2nix = {
          type = "app";
          program = toString (
            writeNu "lazy2nix" ''
              ${resolveDotfiles}

              def main [] {
                exec ${bun} run (
                  dotfiles-dir | path join "nix/modules/home/programs/neovim/lazy2nix/generate.ts"
                )
              }
            ''
          );
        };
      };
    };
}
