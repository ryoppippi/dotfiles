# Values shared between `perSystem` and the host configurations.
{ lib }:
let
  username = "ryoppippi";
in
{
  inherit username;

  darwinHomedir = "/Users/${username}";
  linuxHomedir = "/home/${username}";

  local-skills = lib.fileset.toSource {
    root = ../../.;
    fileset = ../../agents/skills;
  };

  # External skill repositories are pinned here instead of as flake inputs;
  # refresh them with `nix run .#skills-sources-lock`.
  skillRegistry = {
    manifestsDir = ../../registry/sources;
    lockFile = ../../registry/sources.lock.json;
  };
}
