{ inputs, constants, ... }:
{
  perSystem =
    {
      pkgs,
      system,
      writeNu,
      ...
    }:
    let
      homedir =
        if pkgs.stdenv.hostPlatform.isDarwin then constants.darwinHomedir else constants.linuxHomedir;

      nvimxLock = inputs.nvimx.apps.${system}.lock.program;
    in
    {
      apps = {
        # The same `nvimx-lock` home-manager installs, runnable before the first
        # switch and in CI. It rewrites nvim/nvimx-lock/ in the working tree, so
        # it needs the repository, not the store copy of it.
        nvim-lock = {
          type = "app";
          program = toString (
            writeNu "nvim-lock" ''
              def dotfiles-dir [] {
                let configured = $env | get --optional DOTFILES_DIR | default "${homedir}/ghq/github.com/ryoppippi/dotfiles"
                if ($configured | path type) == "dir" { $configured } else { pwd }
              }

              # --wrapped so --update and friends reach nvimx-lock untouched
              def --wrapped main [...rest] {
                let root = dotfiles-dir
                exec ${nvimxLock} --config ($root | path join "nvim") --out ($root | path join "nvim/nvimx-lock") ...$rest
              }
            ''
          );
        };
      };
    };
}
