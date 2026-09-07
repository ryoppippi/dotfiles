{
  perSystem =
    {
      config,
      pkgs,
      lib,
      writeNu,
      ...
    }:
    let
      fishIndent = lib.getExe' pkgs.fish "fish_indent";
      gitleaks = lib.getExe pkgs.gitleaks;
      nufmt = lib.getExe pkgs.nufmt;
      oxfmt = lib.getExe pkgs.oxfmt;
      renovateConfigValidator = lib.getExe' pkgs.renovate "renovate-config-validator";
      treefmt = lib.getExe config.treefmt.build.wrapper;
    in
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs = {
          nixfmt = {
            enable = true;
            package = pkgs.nixfmt-rfc-style;
          };
          stylua.enable = true;
          shfmt.enable = true;
        };
        settings = {
          global.excludes = [
            ".git/**"
            "*.lock"
          ];
          formatter = {
            oxfmt = {
              command = oxfmt;
              options = [ "--no-error-on-unmatched-pattern" ];
              includes = [ "*" ];
              excludes = [
                "nvim/template/**"
                "nvim/lazy-lock.json"
              ];
            };
            gitleaks = {
              command = gitleaks;
              options = [
                "detect"
                "--no-git"
                "--exit-code"
                "0"
              ];
              includes = [ "*" ];
              excludes = [
                "*.png"
                "*.jpg"
                "*.jpeg"
                "*.gif"
                "*.ico"
                "*.pdf"
                "*.woff"
                "*.woff2"
                "*.ttf"
                "*.eot"
                "node_modules/**"
                ".direnv/**"
                "nix/packages/node/**/package-lock.json"
              ];
            };
            renovate-validator = {
              command = renovateConfigValidator;
              options = [ "--strict" ];
              includes = [
                ".github/renovate.json5"
              ];
            };
            fish-indent = {
              command = fishIndent;
              options = [ "--write" ];
              includes = [ "*.fish" ];
            };
            nufmt = {
              command = nufmt;
              includes = [ "*.nu" ];
            };
          };
        };
      };

      pre-commit = {
        check.enable = false;
        settings.hooks = {
          treefmt = {
            enable = true;
            package = config.treefmt.build.wrapper;
          };
          deadnix.enable = true;
          statix.enable = true;
        };
      };

      apps.fmt = {
        type = "app";
        program = toString (
          writeNu "treefmt-wrapper" ''
            # --wrapped so unknown flags reach treefmt instead of being parsed
            # as flags to main.
            def --wrapped main [...rest] {
              exec ${treefmt} ...$rest
            }
          ''
        );
      };

      devShells.default = pkgs.mkShell {
        shellHook = ''
          ${config.pre-commit.installationScript}
        '';
      };
    };
}
