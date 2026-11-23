{ pkgs, lib, ... }:
{
  home.packages = [ pkgs.kache ];

  # An environment variable rather than `build.rustc-wrapper` in
  # ~/.cargo/config.toml, so build tools that unset RUSTC_WRAPPER to bypass
  # caching still can.
  home.sessionVariables.RUSTC_WRAPPER = lib.getExe pkgs.kache;
}
