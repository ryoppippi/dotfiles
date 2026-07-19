{
  description = "ryoppippi's home-manager configuration";

  nixConfig = {
    extra-substituters = [
      "https://cache.numtide.com"
      "https://ryoppippi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
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

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    llm-agents.url = "github:numtide/llm-agents.nix";

    nix-claude-code = {
      url = "github:ryoppippi/nix-claude-code";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-bun = {
      url = "github:ryoppippi/nix-bun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    moonbit-overlay = {
      url = "github:moonbit-community/moonbit-overlay";
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

    agent-browser-skill = {
      url = "github:vercel-labs/agent-browser";
      flake = false;
    };

    tgrab-skill = {
      url = "github:ryoppippi/tgrab";
      flake = false;
    };

    cmux-skill = {
      url = "github:manaflow-ai/cmux";
      flake = false;
    };

    nix-filter.url = "github:numtide/nix-filter";

  };

  outputs =
    inputs@{
      self,
      flake-parts,
      nixpkgs,
      nix-darwin,
      nix-homebrew,
      home-manager,
      llm-agents,
      nix-claude-code,
      nix-bun,
      moonbit-overlay,
      treefmt-nix,
      git-hooks,
      gh-nippou,
      gh-graph,
      brew-nix,
      fish-na,
      nix-index-database,
      agent-skills,
      ast-grep-skill,
      agent-browser-skill,
      tgrab-skill,
      cmux-skill,
      nix-filter,
      ...
    }:
    let
      username = "ryoppippi";
      darwinHomedir = "/Users/${username}";
      linuxHomedir = "/home/${username}";

      local-skills = nix-filter {
        root = self;
        include = [ "agents/skills" ];
      };

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
            llm-agents.overlays.shared-nixpkgs
            (_final: _prev: {
              _nix-claude-code = nix-claude-code;
            })
            nix-bun.overlays.default
            moonbit-overlay.overlays.default
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
                      agent-browser-skill
                      tgrab-skill
                      cmux-skill
                      ;
                    inherit local-skills;
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
          inherit (localPkgs) lib;
          inherit (localPkgs.stdenv) isDarwin;
          homedir = if isDarwin then darwinHomedir else linuxHomedir;
          hostname = username;
          bash = lib.getExe localPkgs.bash;
          darwinRebuild = lib.getExe nix-darwin.packages.${system}.darwin-rebuild;
          fishIndent = lib.getExe' localPkgs.fish "fish_indent";
          gitleaks = lib.getExe localPkgs.gitleaks;
          neovim = lib.getExe localPkgs.neovim;
          nom = lib.getExe localPkgs.nix-output-monitor;
          oxfmt = lib.getExe localPkgs.oxfmt;
          renovateConfigValidator = lib.getExe' localPkgs.renovate "renovate-config-validator";
          treefmt = lib.getExe config.treefmt.build.wrapper;

          # Detect AI agent environments to skip nix-output-monitor
          isAgentCheck = ''
            IS_AI_AGENT=false
            for var in CLAUDE_CODE CLAUDECODE CODEX_SANDBOX CODEX_THREAD_ID GEMINI_CLI OPENCODE AUGMENT_AGENT GOOSE_PROVIDER CURSOR_AGENT AI_AGENT; do
              eval "val=\''${!var:-}"
              if [ -n "$val" ]; then
                IS_AI_AGENT=true
                break
              fi
            done
          '';
          nixBuildFlags = lib.optionalString isDarwin " --accept-flake-config --print-build-logs --show-trace";
          darwinBuildFlags = lib.optionalString isDarwin " --option accept-flake-config true --print-build-logs --show-trace";
          sudoKeepAlive = lib.optionalString isDarwin ''
            if [ -t 0 ]; then
              sudo -v
              (
                while kill -0 "$$" 2>/dev/null; do
                  sudo -n -v || exit 0
                  sleep 60
                done
              ) &
              SUDO_KEEPALIVE_PID=$!
              trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true' EXIT
            fi
          '';
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
                  exec ${bash} \
                    ${./nix/modules/home/programs/neovim/check.sh} \
                    "$DOTFILES_DIR/nvim" \
                    "$HOME/.local/share/nvim/lazy" \
                    ${neovim}
                ''
              );
            };

            build = {
              type = "app";
              program = toString (
                localPkgs.writeShellScript (if isDarwin then "darwin-build" else "home-manager-build") ''
                  set -e
                  ${isAgentCheck}
                  echo "Building ${if isDarwin then "darwin" else "Home Manager"} configuration..."
                  if [ "$IS_AI_AGENT" = true ]; then
                    nix build .#${
                      if isDarwin then
                        "darwinConfigurations.${hostname}.system"
                      else
                        "homeConfigurations.${username}.activationPackage"
                    }${nixBuildFlags}
                  else
                    ${nom} build .#${
                      if isDarwin then
                        "darwinConfigurations.${hostname}.system"
                      else
                        "homeConfigurations.${username}.activationPackage"
                    }${nixBuildFlags}
                  fi
                  echo "Build successful! Run 'nix run .#switch' to apply."
                ''
              );
            };

            switch = {
              type = "app";
              program = toString (
                localPkgs.writeShellScript (if isDarwin then "darwin-switch" else "home-manager-switch") ''
                  set -eo pipefail
                  ${isAgentCheck}
                  ${sudoKeepAlive}
                  echo "Building and switching to ${if isDarwin then "darwin" else "Home Manager"} configuration..."
                  if [ "$IS_AI_AGENT" = true ]; then
                    ${
                      if isDarwin then
                        "sudo ${darwinRebuild} switch --flake .#${hostname}${darwinBuildFlags}"
                      else
                        "nix run nixpkgs#home-manager -- switch --flake .#${username}"
                    }
                  else
                    ${
                      if isDarwin then
                        "sudo ${darwinRebuild} switch --flake .#${hostname}${darwinBuildFlags} |& ${nom}"
                      else
                        "nix run nixpkgs#home-manager -- switch --flake .#${username} |& ${nom}"
                    }
                  fi
                  echo "Clearing fish cache..."
                  rm -rf "$TMPDIR/fish-cache"
                  echo "Done!"
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

            # Regenerate the Nix-served lazy.nvim plugin sources from the
            # runtime plugin table and lazy-lock.json. Runs against the
            # working tree (not the store copy) because it writes the
            # generated files back into the repository.
            lazy2nix = {
              type = "app";
              program = toString (
                localPkgs.writeShellScript "lazy2nix" ''
                  set -e
                  : "''${DOTFILES_DIR:=${homedir}/ghq/github.com/ryoppippi/dotfiles}"
                  if [ ! -d "$DOTFILES_DIR" ]; then
                    DOTFILES_DIR="$(pwd)"
                  fi
                  export PATH=${localPkgs.bun}/bin:$PATH
                  exec bun run "$DOTFILES_DIR/nix/modules/home/programs/neovim/lazy2nix/generate.ts"
                ''
              );
            };

            fmt = {
              type = "app";
              program = toString (
                localPkgs.writeShellScript "treefmt-wrapper" ''
                  exec ${treefmt} "$@"
                ''
              );
            };

            update-node-packages = {
              type = "app";
              program = toString (
                localPkgs.writeShellScript "update-node-packages" ''
                  set -e
                  exec ${bash} nix/packages/node/update.sh "$@"
                ''
              );
            };
          };

          # Expose custom overlay packages as flake outputs so nix-update --flake
          # can target them (e.g. `nix-update --flake git-now`).
          packages = {
            inherit (localPkgs)
              git-now
              roots
              gh-user-stars
              gh-triage
              ;
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
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = false;
                user = username;
                autoMigrate = true;
                mutableTaps = true;
              };
            }

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
                          agent-browser-skill
                          tgrab-skill
                          cmux-skill
                          ;
                        inherit local-skills;
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
