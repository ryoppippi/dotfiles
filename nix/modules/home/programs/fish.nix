{ pkgs, fish-na, ... }:
{
  programs.fish = {
    enable = true;

    plugins = [
      # Plugins from nixpkgs (cached and maintained)
      {
        name = "autopair-fish";
        src = pkgs.fishPlugins.autopair-fish.src;
      }
      {
        name = "bass";
        src = pkgs.fishPlugins.bass.src;
      }
      {
        name = "fzf";
        src = pkgs.fishPlugins.fzf.src;
      }
      {
        name = "fish-bd";
        src = pkgs.fishPlugins.fish-bd.src;
      }
      {
        name = "hydro";
        src = pkgs.fishPlugins.hydro.src;
      }
      {
        name = "spark";
        src = pkgs.fishPlugins.spark.src;
      }

      # GHQ integration
      {
        name = "fish-ghq";
        src = pkgs.fetchFromGitHub {
          owner = "decors";
          repo = "fish-ghq";
          rev = "cafaaabe63c124bf0714f89ec715cfe9ece87fa2";
          sha256 = "sha256-6b1zmjtemNLNPx4qsXtm27AbtjwIZWkzJAo21/aVZzM=";
        };
      }

      # Mock command for testing
      {
        name = "fish-mock";
        src = pkgs.fetchFromGitHub {
          owner = "matchai";
          repo = "fish-mock";
          rev = "f3be4d0624c68007722d1c6f66e7f252f0c8dcc7";
          sha256 = "sha256-OXr/qJlC2FQdV1JC9mQ0xgvBcn3b2MxA9LN8rvJvGF4=";
        };
      }

      # Environment variable helper
      {
        name = "ev-fish";
        src = pkgs.fetchFromGitHub {
          owner = "joehillen";
          repo = "ev-fish";
          rev = "b1dcef66ef83258f42f31fef1c7feff2a4ea8b2b";
          sha256 = "sha256-RMzr+kljBRqB/zmGTNMMLFNKV7XQqvqS9i2jOhV+fGg=";
        };
      }

      # Replay bash/zsh commands in fish
      {
        name = "replay.fish";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "replay.fish";
          rev = "bd8e5b89ec78313538e747f0292fcfa4662f2d26";
          sha256 = "sha256-O/uKB+6EhXAWL1FoQ7iyRcK+sdQKLiRs3nNz5BubwEE=";
        };
      }

      # Abbreviation tips
      {
        name = "fish-abbreviation-tips";
        src = pkgs.fetchFromGitHub {
          owner = "gazorby";
          repo = "fish-abbreviation-tips";
          rev = "8ed76a62bb044ba4ad8e3e6832640178880df485";
          sha256 = "sha256-F1t81VliD+v6WEWqj1c1ehFBXzqLyumx5vV46s/FZRU=";
        };
      }

      # Bun + Deno + Node switcher
      {
        name = "bdf.fish";
        src = pkgs.fetchFromGitHub {
          owner = "ryoppippi";
          repo = "bdf.fish";
          rev = "09d7dfc3e2e11196a5172e93406a8d7325f5a64f";
          sha256 = "sha256-lXNHi7AIFd3h8nEPnTaCdNwfZrrnvWgRsybPH/X9peY=";
        };
      }

      # PATH editor
      {
        name = "pathed.fish";
        src = pkgs.fetchFromGitHub {
          owner = "yuys13";
          repo = "pathed.fish";
          rev = "aea5ff4bad83c8f5af9b5c8f4e5343dbed66c3e5";
          sha256 = "sha256-7pzxygxusX/hSoFDY7E6Fk0O1mz40e3J8VnqmCCzDUg=";
        };
      }

      # Text expansion for fish
      {
        name = "puffer-fish";
        src = pkgs.fetchFromGitHub {
          owner = "nickeb96";
          repo = "puffer-fish";
          rev = "12d062eae0ad24f4ec20593be845ac30cd4b5923";
          sha256 = "sha256-2niYj0NLfmVIQguuGTA7RrPIcorJEPkxhH6Dhcy+6Bk=";
        };
      }

      # Nix environment support
      {
        name = "nix-env.fish";
        src = pkgs.fetchFromGitHub {
          owner = "lilyball";
          repo = "nix-env.fish";
          rev = "7b65bd228429e852c8fdfa07601159130a818cfa";
          sha256 = "sha256-RG/0rfhgq6aEKNZ0XwIqOaZ6K5S4+/Y5EEMnIdtfPhk=";
        };
      }

      # Runtime version switcher
      {
        name = "fish-na";
        src = fish-na;
      }

      # Customisable key bindings
      {
        name = "by-binds-yourself";
        src = pkgs.fetchFromGitHub {
          owner = "atusy";
          repo = "by-binds-yourself";
          rev = "d6d97da36cf3ad111e37daa2ce5adc85d11f5e99";
          sha256 = "sha256-FXBWm7WhkIyZoGuaALN+aKB+WI5yQYhH/F+RaUZr/QQ=";
        };
      }
    ];
  };
}
