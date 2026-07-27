_final: prev:
let
  inherit (prev) lib stdenv;
in
{
  # `bun build --compile` appends the JS bundle after the ELF image, so
  # `patchelf --shrink-rpath` in fixupPhase truncates the payload and leaves a
  # binary that exits silently (`hunk --version` prints nothing, so the
  # versionCheck hook fails the build). nixpkgs' own hunk package disables
  # fixup for the same reason; upstream llm-agents.nix only sets `dontStrip`.
  llm-agents =
    prev.llm-agents
    // lib.optionalAttrs stdenv.hostPlatform.isLinux {
      hunk = prev.llm-agents.hunk.overrideAttrs (_: {
        dontFixup = true;
      });
    };
}
