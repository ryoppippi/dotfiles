# Expansion for the `nixpkgs:<attr>` abbreviation: `nixpkgs:ripgrep` becomes
# `gh-nix nix run nixpkgs#ripgrep`.
function _abbr_nixpkgs_run --argument-names token
    string replace --regex '^nixpkgs:' 'gh-nix nix run nixpkgs#' -- $token
end
