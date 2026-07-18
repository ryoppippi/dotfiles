# lazy.nvim plugin directory name -> nixpkgs vimPlugins attribute.
#
# Mapped plugins are served read-only from the Nix store and follow the
# nixpkgs revision; lazy.nvim treats them as dev plugins, so it IGNORES the
# spec's version/branch/commit pins and build steps, and keeps them out of
# lazy-lock.json. Keep a plugin out of this map when:
#   - nixpkgs does not package it, or
#   - the spec's pin must keep applying (other.nvim pins a commit,
#     rustaceanvim pins version "^5", mini.* request the stable branch while
#     nixpkgs ships main-branch snapshots, nvim-treesitter-context relies on
#     the locked fork API), or
#   - the plugin needs its build step on update (kanagawa.nvim recompiles
#     its theme cache via :KanagawaCompile).
# Unmapped plugins keep being git-cloned by lazy.nvim at the lazy-lock.json
# commit.
#
# The attrset KEY must equal lazy.nvim's plugin directory name (the spec's
# repo basename, or its explicit name= override — the same string lazy uses
# as lazy-lock.json key): the Lua side resolves $LAZY_NIX_PLUGINS/<key>. A
# wrong key fails silently, because dev.fallback just git-clones the plugin
# instead. The nixpkgs pname usually matches that name (attribute names do
# not: dots are normalised to dashes) but is only a heuristic — e.g.
# "lsp_lines" and "schemastore.nvim" differ from their pnames.
#
# Every entry is evaluated, so drop the entry when removing a plugin;
# otherwise `nix run .#switch` breaks once nixpkgs renames the attribute.
{
  "actions-preview.nvim" = "actions-preview-nvim";
  "blink-cmp-git" = "blink-cmp-git";
  "blink-cmp-spell" = "blink-cmp-spell";
  "blink-emoji.nvim" = "blink-emoji-nvim";
  "blink.cmp" = "blink-cmp";
  "bufferline.nvim" = "bufferline-nvim";
  "bufresize.nvim" = "bufresize-nvim";
  "colorful-winsep.nvim" = "colorful-winsep-nvim";
  "context_filetype.vim" = "context_filetype-vim";
  "copilot.lua" = "copilot-lua";
  "crates.nvim" = "crates-nvim";
  "dial.nvim" = "dial-nvim";
  "diffview.nvim" = "diffview-nvim";
  "dropbar.nvim" = "dropbar-nvim";
  "fileline.nvim" = "fileline-nvim";
  "flash.nvim" = "flash-nvim";
  "flatten.nvim" = "flatten-nvim";
  "git-conflict.nvim" = "git-conflict-nvim";
  "gitignore.nvim" = "gitignore-nvim";
  "gitsigns.nvim" = "gitsigns-nvim";
  "glance.nvim" = "glance-nvim";
  "highlight-undo.nvim" = "highlight-undo-nvim";
  "hlargs.nvim" = "hlargs-nvim";
  "hlchunk.nvim" = "hlchunk-nvim";
  "inc-rename.nvim" = "inc-rename-nvim";
  "lackluster.nvim" = "lackluster-nvim";
  "lazy.nvim" = "lazy-nvim";
  "lsp-format.nvim" = "lsp-format-nvim";
  "marks.nvim" = "marks-nvim";
  "mini.icons" = "mini-icons";
  "mkdir.nvim" = "mkdir-nvim";
  "noice.nvim" = "noice-nvim";
  "nui.nvim" = "nui-nvim";
  "nvim-bqf" = "nvim-bqf";
  "nvim-early-retirement" = "nvim-early-retirement";
  "nvim-FeMaco.lua" = "nvim-FeMaco-lua";
  "nvim-highlight-colors" = "nvim-highlight-colors";
  "nvim-lightbulb" = "nvim-lightbulb";
  "nvim-lspconfig" = "nvim-lspconfig";
  "nvim-luadev" = "nvim-luadev";
  "nvim-treesitter-textobjects" = "nvim-treesitter-textobjects";
  "nvim-treesitter" = "nvim-treesitter";
  "nvim-ts-autotag" = "nvim-ts-autotag";
  "nvim-ts-context-commentstring" = "nvim-ts-context-commentstring";
  "octo.nvim" = "octo-nvim";
  "oil-git-status.nvim" = "oil-git-status-nvim";
  "oil.nvim" = "oil-nvim";
  "package-info.nvim" = "package-info-nvim";
  "parinfer-rust" = "parinfer-rust";
  "persistence.nvim" = "persistence-nvim";
  "plenary.nvim" = "plenary-nvim";
  "quick-scope" = "quick-scope";
  "quicker.nvim" = "quicker-nvim";
  "rainbow-delimiters.nvim" = "rainbow-delimiters-nvim";
  "satellite.nvim" = "satellite-nvim";
  "schemastore.nvim" = "SchemaStore-nvim";
  "snacks.nvim" = "snacks-nvim";
  "sort.nvim" = "sort-nvim";
  "substitute.nvim" = "substitute-nvim";
  "todo-comments.nvim" = "todo-comments-nvim";
  "vim-asterisk" = "vim-asterisk";
  "vim-illuminate" = "vim-illuminate";
  "vim-manpager" = "vim-manpager";
  "vim-matchup" = "vim-matchup";
  "vim-prettyprint" = "vim-prettyprint";
  "vim-quickrun" = "vim-quickrun";
  "vim-repeat" = "vim-repeat";
  "vim-startuptime" = "vim-startuptime";
  "vim-table-mode" = "vim-table-mode";
  "vim-textobj-user" = "vim-textobj-user";
  "vim-visual-multi" = "vim-visual-multi";
  "which-key.nvim" = "which-key-nvim";
}
