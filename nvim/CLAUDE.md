# Neovim Configuration

## Structure

- `init.lua` - Entry point
- `lua/` - Lua configuration modules
- `lazy-lock.json` - Plugin lockfile (Lazy.nvim)

## Plugin Manager

Using **Lazy.nvim** for plugin loading, with most plugins served read-only
from the Nix store:

- `nix/modules/home/programs/neovim/plugins.nix` maps lazy.nvim plugin names
  to nixpkgs `vimPlugins` attributes; mapped plugins are provided via a
  linkFarm exposed as `$LAZY_NIX_PLUGINS` and resolved through lazy.nvim's
  `dev.path`. They update with `nix run .#update`, are NOT tracked in
  `lazy-lock.json`, and their spec `version`/`branch`/`commit` pins and
  `build` steps do NOT apply.
- Plugins absent from that map (not packaged in nixpkgs, or intentionally
  excluded because a spec pin or build step must keep applying — see the
  plugins.nix header) are git-cloned by Lazy.nvim and pinned by
  `lazy-lock.json`.
- Own plugins (`ryoppippi/*`) resolve to the local `~/ghq` checkout.
