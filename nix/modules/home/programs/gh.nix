{
  pkgs,
  ...
}:
{
  programs.gh = {
    enable = true;

    extensions = [
      # Extensions available in nixpkgs
      pkgs.gh-markdown-preview
      pkgs.gh-dash
      pkgs.gh-poi
      pkgs.gh-notify
      pkgs.gh-do
      pkgs.gh-stack

      # Custom extensions from overlay
      pkgs.gh-nippou
      pkgs.gh-user-stars
      pkgs.gh-triage
    ];
  };
}
