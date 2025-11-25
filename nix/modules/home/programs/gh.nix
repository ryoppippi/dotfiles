{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.gh = {
    enable = true;

    extensions = [
      # Extensions available in nixpkgs
      pkgs.gh-markdown-preview
      pkgs.gh-dash
      pkgs.gh-actions-cache
      pkgs.gh-poi
      pkgs.gh-notify

      # Custom extensions from overlay
      pkgs.gh-do
      pkgs.gh-graph
      pkgs.gh-nippou
      pkgs.gh-user-stars
      pkgs.gh-triage
    ];
  };
}
