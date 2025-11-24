# Cachix configuration for binary caches
# This file centralises substituters and public keys used across the flake
let
  substituters = [
    "https://cache.nixos.org"
    "https://numtide.cachix.org"
    "https://devenv.cachix.org"
    "https://ryoppippi-dotfiles.cachix.org"
  ];

  publicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "numtide.cachix.org-1:2uk1h3hh8XGkFfQJSTgNTg/WRNsE+lTZYOB+VkZdvJo="
    "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    "ryoppippi-dotfiles.cachix.org-1:REPLACE_WITH_YOUR_PUBLIC_KEY"
  ];
in
{
  # Export for use in modules
  inherit substituters publicKeys;

  # Flake-specific nixConfig format
  flakeConfig = {
    extra-substituters = substituters;
    extra-trusted-public-keys = publicKeys;
  };
}
