{
  pkgs,
  lib,
  ...
}:
let
  realTmux = lib.getExe pkgs.tmux;
  bun = lib.getExe pkgs.bun;
  wezterm = lib.getExe pkgs.wezterm;

  shimScript = pkgs.writeShellScriptBin "tmux" ''
    export REAL_TMUX="${realTmux}"
    export WEZTERM_CLI="${wezterm}"
    exec "${bun}" run "${./tmux-shim.ts}" "$@"
  '';
in
{
  home.packages = [ shimScript ];
}
