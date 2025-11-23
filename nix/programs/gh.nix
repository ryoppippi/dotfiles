{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.gh = {
    enable = true;

    extensions = with pkgs; [
      # Extensions available in nixpkgs
      gh-markdown-preview
      gh-dash
      gh-actions-cache
      gh-poi
      gh-copilot
      gh-notify
    ];
  };

  # Install gh extensions not available in nixpkgs
  home.activation.installGhExtensions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    $DRY_RUN_CMD ${pkgs.gh}/bin/gh extension install k1LoW/gh-do --force || true
    $DRY_RUN_CMD ${pkgs.gh}/bin/gh extension install kawarimidoll/gh-graph --force || true
    $DRY_RUN_CMD ${pkgs.gh}/bin/gh extension install korosuke613/gh-user-stars --force || true
    $DRY_RUN_CMD ${pkgs.gh}/bin/gh extension install k1LoW/gh-triage --force || true
  '';
}
