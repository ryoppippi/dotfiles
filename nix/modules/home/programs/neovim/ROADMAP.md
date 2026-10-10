# Neovim plugin management roadmap

Design notes for where the Nix-served Neovim plugin setup is heading. Not a
committed plan — a record of the decisions reached so the next change does
not re-litigate them.

## Layers

Plugin management splits into two independent layers:

- **Supply** — how a plugin's files get onto disk. Ours: Nix, via
  [nvimx](https://github.com/myuron/nvimx).
- **Loader** — how a plugin is loaded, lazily or eagerly. Ours: lazy.nvim.

These are orthogonal. "Serve everything from Nix" is a supply-layer choice;
"which loader" is a separate one. Confusing them wastes time.

## Current state: nvimx (lazy.nvim loader + Nix supply)

nvimx runs the lazy.nvim spec in a headless Neovim at lock time
(`nvimx-lock`, or `nix run .#nvim-lock`), resolves every plugin — spec
`version`/`branch`/`commit` included — and pins it as an input of the
generated `nvim/nvimx-lock/flake.lock`. The home-manager build reads that
lock purely, builds one derivation per plugin into a `linkFarm`, and wraps
Neovim with a bootstrap that forces lazy.nvim's `dev` path at the farm and
switches its git/install/checker machinery off.

What this bought over the previous lazy2nix setup:

- **every third-party plugin is Nix-supplied**: no git-managed excludes, no
  `lazy-lock.json`, no activation-time `Lazy! restore`; once the store is
  populated a new machine only needs the `dev = true` checkouts in ~/ghq
- **spec pins apply again**: `version = "1.*"`, `branch = "stable"` and
  `commit = ...` are resolved at lock time instead of being ignored
- **build steps are handled**: blink.cmp's Rust matcher is built from the
  locked source; unrunnable builds are reported by `nvimx-lock`
- **no hand-written hacks**: the `dev.path` function, the helptags
  monkeypatch and the pinned-rev carry-forward wart are gone, along with
  `generate.ts`/`dump.lua`

Local escape hatches in use (`default.nix`):

- `plugins.nixpkgsFallback = [ "parinfer-rust" ]` — its spec build runs
  `nix develop`, which cannot work in the sandbox
- `treesitter.grammars = "all"` — parsers from nixpkgs merged into the
  locked nvim-treesitter; grammars nixpkgs lacks (moonbit) still go through
  `:TSInstall` with the `tree-sitter` CLI
- kanagawa's `build = ":KanagawaCompile"` is skipped; `compile = true`
  makes it compile into `stdpath("state")` on first load anyway

### Updating

- adding/removing a plugin: the pre-commit hook re-runs `nix run .#nvim-lock`
  when `nvim/lua/plugin/` changes; existing pins never move
- moving pins: `nix run .#nvim-lock -- --update [name...]`, then commit and
  switch. Unlike lazy2nix, nixpkgs updates no longer move plugins, so this
  is the only way they advance — a scheduled bot for it is still TODO

## Possible target: Nix supply + lz.n loader

Replace lazy.nvim with [lz.n](https://github.com/nvim-neorocks/lz.n), a
purpose-built lazy-loader that never fetches. The tool boundary would then
match the responsibility boundary — supply is Nix, loading is lz.n.

nvimx removed most of the motivation: the hacks that made lazy.nvim feel
like "two package managers, one half-disabled" now live upstream in nvimx's
bootstrap rather than in this repository, and lazy.nvim's spec is what
nvimx uses as the source of truth for "which plugins at which version".
Moving to lz.n would mean giving that up and writing a manifest again, so
this is only worth revisiting if lazy.nvim itself becomes a problem
(startup cost, maintenance) — not for architectural tidiness.

If it is revisited:

1. Prototype lz.n + `packpath` on a branch; port a handful of specs.
2. Verify lazy-loading parity, especially `event` triggers that must
   re-fire so plugins attach to the current buffer.
3. Compare startup with `vim-startuptime` against the current setup.
4. Decide the new source of truth (lz.n specs + pins file, or a manifest).

## Rejected: lazy2nix (home-grown generator)

The previous setup: a Bun script mapped the runtime plugin table to
nixpkgs `vimPlugins` attributes or pinned `fetchFromGitHub` sources, and
lazy.nvim's `dev.path` was pointed at the resulting farm. It worked, but
spec pins and build steps were silently ignored for Nix-served plugins, so
about a dozen plugins had to stay git-managed by lazy.nvim, and lazy.nvim
dropping `dev` plugins from its lock forced a rev carry-forward hack.
nvimx solves the same problem upstream, more completely.

## Rejected: vim.pack (Neovim 0.12)

vim.pack has a lockfile (`nvim-pack-lock.json`) and version constraints, but
no `event`/`ft`/`keys` lazy-loading — it would all be DIY. More to the
point, under Nix its git/install/lock machinery duplicates what Nix already
does. It suits people not using Nix — not this setup.

## Rejected: full nixvim

Config moves into Nix (or Lua-in-Nix-strings), killing fast iteration and
config-file tooling, and rewriting ~90 Lua spec files. nvimx keeps the
native Lua specs and the out-of-store config symlink while still pinning
every plugin in Nix.
