# lazy2nix roadmap

Design notes for where the Nix-served Neovim plugin setup is heading. Not a
committed plan — a record of the decisions reached so the next change does
not re-litigate them.

## Layers

Plugin management splits into two independent layers:

- **Supply** — how a plugin's files get onto disk. Ours: Nix. nixpkgs for
  packaged plugins, pinned `fetchFromGitHub` for the rest, joined into one
  `linkFarm`. lazy2nix generates this.
- **Loader** — how a plugin is loaded, lazily or eagerly. Ours: lazy.nvim,
  via its `dev` mechanism pointed at the Nix `linkFarm`.

These are orthogonal. "Serve everything from Nix" is a supply-layer choice;
"which loader" is a separate one. Confusing them wastes time.

## Current state (A): lazy.nvim loader + Nix supply

lazy.nvim owns the loader layer and, through lazy2nix, delegates the supply
layer to Nix. Two lazy.nvim-specific hacks make this work:

- `dev.path` is a function returning the `linkFarm` entry (and `~/ghq` for
  own plugins); `patterns = { "" }` marks every plugin `dev`.
- the docs (helptags) task is monkeypatched to skip the read-only store.

lazy2nix reads two lazy.nvim artifacts: the resolved plugin table (via
`dump.lua`) and `lazy-lock.json` (for pinned revs). Because lazy.nvim drops
`dev` plugins from the lock file, pinned revs are carried forward from the
previous `pinned-plugins.json` once a plugin leaves the lock — a wart that
only exists because two package managers overlap.

Works and is stable. The discomfort is conceptual: lazy.nvim is a full
package manager, and we use only its loader half while Nix does the rest —
so there are effectively two package managers, one half-disabled.

## Interim step: pin the excludes (supply layer only)

Convert the ~12 `config.json` excludes from lazy.nvim-git-managed to
lazy2nix-pinned (at their current lock commit). Effect:

- every plugin is Nix-supplied; `lazy-lock.json` becomes empty and
  lazy.nvim's git/fetch machinery goes fully idle
- new machines are fully offline
- the "lazy drops dev plugins" carry-forward wart disappears

Cost: small (extend `config.json` `exclude` -> `pin`, teach `generate.ts`
to pin instead of skip). Loader stays lazy.nvim. Excluded plugins keep
their pinned version; a `version`/`build` that must change requires an
explicit rev bump (kanagawa's `:KanagawaCompile` must be re-run on bump —
generate.ts should warn). Keep `dev.fallback` and the activation restore as
a safety net for when generation fails offline.

## Target (B): Nix supply + lz.n loader

Replace lazy.nvim with [lz.n](https://github.com/nvim-neorocks/lz.n), a
purpose-built lazy-loader that never fetches. This makes the tool boundary
match the responsibility boundary — supply is Nix, loading is lz.n — and
removes the "two package managers" discomfort at its root.

This is the same architecture nixvim uses internally (Nix supply + lz.n
loader). The difference from nixvim is the **config layer only**: B keeps
the native Lua spec files, whereas nixvim writes config as Nix module
options (or Lua-in-Nix-strings). B therefore keeps:

- fast iteration (edit Lua, restart — the out-of-store `linkNvimConfig`
  symlink; nixvim needs a rebuild per change)
- lua-language-server / stylua on real `.lua` files
- uniform handling of niche plugins nixvim has no module for
- no framework lock-in

### What changes in lazy2nix under B

- **stays**: the generator core (nixpkgs pname match -> fetchFromGitHub pin
  -> hash cache) and the `linkFarm`. Loader-agnostic.
- **reshapes**: the `linkFarm` becomes a `pack/lazy2nix/opt/*` layout added
  to `packpath` (small change).
- **dies**: `dump.lua` (no `lazy.core.config` under lz.n) and the
  `lazy-lock.json` dependency (lz.n has no lockfile; `pinned-plugins.json`
  already is lazy2nix's own lock).
- **new work**: a source-of-truth for "which plugins at which version",
  since lazy.nvim no longer provides it. Options: parse the lz.n specs for
  `owner/repo` plus a small pins file, or a single `plugins.toml` manifest.

The `dev.path` hack, the docs monkeypatch, and the lock carry-forward wart
all disappear — they were symptoms of using lazy.nvim as a loader.

### Migration outline

1. Prototype lz.n + `packpath` on a branch; port a handful of specs.
2. Verify lazy-loading parity, especially `event` triggers that must
   re-fire so plugins attach to the current buffer (lazy.nvim does this
   carefully; confirm lz.n or the shim matches).
3. Compare startup with `vim-startuptime` against A.
4. Port the remaining specs (lz.n's spec shape is close to lazy.nvim's:
   `event`/`ft`/`keys`/`cmd` carry over; mostly mechanical).
5. Repoint lazy2nix at the new manifest and the `pack/*/opt` layout.

## Rejected: vim.pack (Neovim 0.12)

vim.pack has a lockfile (`nvim-pack-lock.json`) and version constraints, but
no `event`/`ft`/`keys` lazy-loading — it would all be DIY. More to the
point, under Nix its git/install/lock machinery duplicates what Nix already
does. It suits people not using Nix, or the handful of git-managed excludes
— not this setup. If B's loader ever needs replacing, a DIY loader (~200–300
lines: command stubs, FileType autocmds, key stubs with `feedkeys` replay,
event re-fire) is the fallback, but lz.n already solves this.

## Rejected: full nixvim

Config moves into Nix (or Lua-in-Nix-strings), killing fast iteration and
config-file tooling, and rewriting ~90 Lua spec files. B reaches nixvim's
clean loader architecture without paying any of that.
