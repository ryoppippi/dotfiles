_final: prev: {
  # hunk is built with `bun build --compile`. bun 1.3.14 miscomputes where its
  # own runtime image ends once patchelf has rewritten the ELF, so on Linux it
  # emits a standalone executable that embeds the runtime twice and segfaults
  # on startup. nix-bun tracks the latest bun, so `pkgs.bun` is 1.3.14; build
  # this one package with nixpkgs' bun until upstream bun fixes `--compile`.
  llm-agents = prev.llm-agents // {
    hunk = prev.llm-agents.hunk.override {
      bun = prev.bun-nixpkgs;
    };
  };
}
