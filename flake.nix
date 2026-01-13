{
  description = "ryoppippi's home-manager configuration";

  # Note: cachix configuration is defined in nix/cachix.nix
  # but nixConfig must be a literal set, so we inline it here
  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://cache.numtide.com"
      "https://devenv.cachix.org"
      "https://ryoppippi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "ryoppippi.cachix.org-1:b2LbtWNvJeL/qb1B6TYOMK+apaCps4SCbzlPRfSQIms="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents.url = "github:numtide/llm-agents.nix";

    claude-code-overlay = {
      url = "github:ryoppippi/claude-code-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gh-nippou = {
      url = "github:ryoppippi/gh-nippou";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs = {
        brew-api.follows = "brew-api";
        nix-darwin.follows = "nix-darwin";
        nixpkgs.follows = "nixpkgs";
      };
    };

    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };

    rs-arto = {
      url = "github:lambdalisue/rs-arto";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fish-na = {
      url = "github:ryoppippi/fish-na";
      flake = false;
    };

    gh-graph = {
      url = "github:kawarimidoll/gh-graph";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Agent skills framework for managing Claude Code skills
    agent-skills = {
      url = "github:Kyure-A/agent-skills-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Claude Code skills (flake = false for non-flake repos)
    ast-grep-skill = {
      url = "github:ast-grep/claude-skill";
      flake = false;
    };

    # Local skills from this dotfiles repo
    local-skills = {
      url = "path:./claude/skills";
      flake = false;
    };
  };

  outputs =
    inputs@{
      flake-parts,
      nixpkgs,
      nix-darwin,
      home-manager,
      llm-agents,
      claude-code-overlay,
      treefmt-nix,
      git-hooks,
      gh-nippou,
      gh-graph,
      brew-nix,
      fish-na,
      nix-index-database,
      agent-skills,
      ast-grep-skill,
      local-skills,
      ...
    }:
    let
      username = "ryoppippi";
      darwinHomedir = "/Users/${username}";
      linuxHomedir = "/home/${username}";

      # Create pkgs with overlays
      mkPkgs =
        system:
        let
          isDarwin = builtins.match ".*-darwin" system != null;
        in
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (_final: _prev: {
              _llm-agents = llm-agents;
              _claude-code-overlay = claude-code-overlay;
            })
            gh-nippou.overlays.default
            gh-graph.overlays.default
            (import ./nix/overlays/default.nix)
          ]
          ++ nixpkgs.lib.optionals isDarwin [
            brew-nix.overlays.default
          ];
        };

      # Helper to create Linux home configuration
      mkLinuxHomeConfig =
        linuxSystem:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs linuxSystem;
          modules = [
            {
              home.username = username;
              home.homeDirectory = linuxHomedir;
            }
            (
              {
                pkgs,
                config,
                lib,
                ...
              }:
              let
                helpers = import ./nix/modules/lib/helpers { inherit lib; };
              in
              {
                imports = [
                  nix-index-database.hmModules.nix-index
                  agent-skills.homeManagerModules.default

                  (import ./nix/modules/home {
                    inherit
                      pkgs
                      config
                      lib
                      fish-na
                      ast-grep-skill
                      local-skills
                      ;
                    homedir = linuxHomedir;
                    system = linuxSystem;
                    nodePackages = import ./nix/packages/node { inherit pkgs; };
                  })

                  (import ./nix/modules/linux {
                    inherit
                      pkgs
                      config
                      lib
                      helpers
                      ;
                    homedir = linuxHomedir;
                    dotfilesDir = "${linuxHomedir}/ghq/github.com/ryoppippi/dotfiles";
                  })
                ];
              }
            )
          ];
        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [
        treefmt-nix.flakeModule
        git-hooks.flakeModule
      ];

      perSystem =
        {
          config,
          system,
          ...
        }:
        let
          localPkgs = mkPkgs system;
          inherit (localPkgs.stdenv) isDarwin;
          homedir = if isDarwin then darwinHomedir else linuxHomedir;
          hostname = username;
        in
        {
          # Treefmt configuration
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt = {
                enable = true;
                package = localPkgs.nixfmt-rfc-style;
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
                  command = "${localPkgs.oxfmt}/bin/oxfmt";
                  options = [ "--no-error-on-unmatched-pattern" ];
                  includes = [ "*" ];
                  excludes = [
                    "nvim/template/**"
                    "nvim/lazy-lock.json"
                  ];
                };
                gitleaks = {
                  command = "${localPkgs.gitleaks}/bin/gitleaks";
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
                  command = "${localPkgs.renovate}/bin/renovate-config-validator";
                  options = [ "--strict" ];
                  includes = [
                    ".github/renovate.json5"
                  ];
                };
                fish-indent = {
                  command = "${localPkgs.fish}/bin/fish_indent";
                  options = [ "--write" ];
                  includes = [ "*.fish" ];
                };
              };
            };
          };

          # Git hooks configuration
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

          # Apps
          apps = {
            nvim-restore = {
              type = "app";
              program = toString (
                localPkgs.writeShellScript "nvim-restore" ''
                  : "''${DOTFILES_DIR:=${homedir}/ghq/github.com/ryoppippi/dotfiles}"
                  if [ ! -d "$DOTFILES_DIR" ]; then
                    DOTFILES_DIR="$(pwd)"
                  fi
                  exec ${localPkgs.bash}/bin/bash \
                    ${./nix/modules/home/programs/neovim/check.sh} \
                    "$DOTFILES_DIR/nvim" \
                    "$HOME/.local/share/nvim/lazy" \
                    ${localPkgs.neovim}/bin/nvim
                ''
              );
            };

            build = {
              type = "app";
              program = toString (
                localPkgs.writeShellScript (if isDarwin then "darwin-build" else "home-manager-build") ''
                  set -e
                  echo "Building ${if isDarwin then "darwin" else "Home Manager"} configuration..."
                  nix build .#${
                    if isDarwin then
                      "darwinConfigurations.${hostname}.system"
                    else
                      "homeConfigurations.${username}.activationPackage"
                  }
                  echo "Build successful! Run 'nix run .#switch' to apply."
                ''
              );
            };

            switch = {
              type = "app";
              program = toString (
                localPkgs.writeShellScript (if isDarwin then "darwin-switch" else "home-manager-switch") ''
                  set -e
                  echo "Building and switching to ${if isDarwin then "darwin" else "Home Manager"} configuration..."
                  ${
                    if isDarwin then
                      "sudo nix run nix-darwin -- switch --flake .#${hostname}"
                    else
                      "nix run nixpkgs#home-manager -- switch --flake .#${username}"
                  }
                ''
              );
            };

            update = {
              type = "app";
              program = toString (
                localPkgs.writeShellScript "flake-update" ''
                  set -e
                  echo "Updating flake.lock..."
                  nix flake update
                  echo "Done! Run 'nix run .#switch' to apply changes."
                ''
              );
            };

            update-ai-tools = {
              type = "app";
              program = toString (
                localPkgs.writeShellScript "update-ai-tools" ''
                  set -e
                  echo "Updating AI tools inputs..."
                  nix flake update llm-agents
                  echo "Done! Run 'nix run .#switch' to apply changes."
                ''
              );
            };

            fmt = {
              type = "app";
              program = toString (
                localPkgs.writeShellScript "treefmt-wrapper" ''
                  exec ${config.treefmt.build.wrapper}/bin/treefmt "$@"
                ''
              );
            };

            update-node-packages = {
              type = "app";
              program = toString (
                localPkgs.writeShellScript "update-node-packages" ''
                  set -e
                  exec ${localPkgs.bash}/bin/bash nix/packages/node/update.sh "$@"
                ''
              );
            };
          };

          # DevShell with pre-commit hooks
          devShells.default = localPkgs.mkShell {
            shellHook = ''
              ${config.pre-commit.installationScript}
            '';
          };
        };

      flake = {
        # macOS configuration with nix-darwin
        darwinConfigurations.${username} = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";

          modules = [
            (import ./nix/modules/darwin/system.nix {
              pkgs = mkPkgs "aarch64-darwin";
              inherit (nixpkgs) lib;
              inherit username;
              homedir = darwinHomedir;
            })

            nix-index-database.darwinModules.nix-index

            home-manager.darwinModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = false;
                useUserPackages = true;
                extraSpecialArgs = {
                  pkgs = mkPkgs "aarch64-darwin";
                };
                users.${username} =
                  {
                    pkgs,
                    config,
                    lib,
                    ...
                  }:
                  let
                    helpers = import ./nix/modules/lib/helpers { inherit lib; };
                  in
                  {
                    imports = [
                      agent-skills.homeManagerModules.default

                      (import ./nix/modules/home {
                        inherit
                          pkgs
                          config
                          lib
                          fish-na
                          ast-grep-skill
                          local-skills
                          ;
                        homedir = darwinHomedir;
                        system = "aarch64-darwin";
                        nodePackages = import ./nix/packages/node { inherit pkgs; };
                      })

                      (import ./nix/modules/darwin {
                        inherit
                          pkgs
                          config
                          lib
                          helpers
                          ;
                        homedir = darwinHomedir;
                        dotfilesDir = "${darwinHomedir}/ghq/github.com/ryoppippi/dotfiles";
                      })
                    ];
                  };
              };
            }
          ];
        };

        # Linux configurations with standalone Home Manager
        homeConfigurations = {
          ${username} = mkLinuxHomeConfig "x86_64-linux";
          "${username}-aarch64" = mkLinuxHomeConfig "aarch64-linux";
        };
      };
    };
}
