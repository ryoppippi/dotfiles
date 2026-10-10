{ inputs, constants, ... }:
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

      # Built from nvimx's lib rather than taken from its `apps`, which only
      # cover x86_64-linux and aarch64-darwin (myuron/nvimx#76).
      nvimxLock =
        lib.getExe
          (import "${inputs.nvimx}/nix/lib" {
            inherit pkgs;
            lazyNvimSeed = inputs.nvimx.inputs.lazy-nvim;
          }).lockApp;
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
