# Neovim Configuration

## Structure

- `init.lua` - Entry point
- `lua/` - Lua configuration modules
- `lazy-lock.json` - Plugin lockfile (Lazy.nvim)

## Plugin Manager

Using **Lazy.nvim** for plugin loading, with almost all plugins served
read-only from the Nix store via **lazy2nix**
(`nix/modules/home/programs/neovim/lazy2nix/`):

- `nix run .#lazy2nix` regenerates the plugin sources from the runtime
  plugin table: nixpkgs-packaged plugins map to `vimPlugins` attributes
  (`nixpkgs-plugins.nix`), the rest are pinned `fetchFromGitHub` sources at
  the commit `lazy-lock.json` last recorded (`pinned-plugins.json`). Run it
  after adding or removing plugin specs.
- Nix-served plugins are provided via a linkFarm exposed as
  `$LAZY_NIX_PLUGINS` and resolved through lazy.nvim's `dev.path`. nixpkgs
  ones update with `nix run .#update`; pinned ones stay at their pinned
  commit. They are NOT tracked in `lazy-lock.json`, and their spec
  `version`/`branch`/`commit` pins and `build` steps do NOT apply.
- Plugins listed in `lazy2nix/config.json`'s `exclude` (a spec pin or build
  step must keep applying) are git-cloned by Lazy.nvim and pinned by
  `lazy-lock.json`.
- Own plugins (`ryoppippi/*`) resolve to the local `~/ghq` checkout.
