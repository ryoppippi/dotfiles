let
  systemFirst = "system_first";
in
{
  # Node.js and package managers come from each project's Nix dev shell. In vp's
  # default managed mode it downloads its own copies into
  # ~/.local/share/vite-plus even when the dev shell already provides a version
  # that satisfies the project.
  xdg.configFile."vite-plus/config.json".text = builtins.toJSON {
    nodeShimMode = systemFirst;
    packageManagerShimModes = {
      bun = systemFirst;
      npm = systemFirst;
      pnpm = systemFirst;
      yarn = systemFirst;
    };
  };
}
