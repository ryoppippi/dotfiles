local tb = require("utils").toboolean

-- vim.g.enabled_snippet = "vsnip"
vim.g.enabled_snippet = "luasnip"
vim.g["jetpack#copy_method"] = "symlink"
vim.g["jetpack#optimization"] = 1

local function ensure_jetpack()
  local status, _ = pcall(vim.cmd, "packadd vim-jetpack")
  if not status then
    vim.api.nvim_exec(
      [[
        let dir = expand(stdpath('data') ..'/site/pack/jetpack/src/vim-jetpack')
        if !isdirectory(dir)
          autocmd VimEnter * Sync | source $MYVIMRC
          let url = 'https://github.com/tani/vim-jetpack'
          silent execute printf('!git clone --depth 1 %s %s', url, dir)
        endif
        silent execute 'ln -sf ~/.local/share/nvim/site/pack/jetpack/{src,opt}/vim-jetpack'
        packadd vim-jetpack
      ]],
      false
    )
  end
end

local function load_plugins(plugin_list)
  require("jetpack").startup(function(use)
    for _, plugin in ipairs(plugin_list) do
      local enabled = plugin.enabled
      if enabled ~= false then
        use(plugin)
      end
    end
  end)
end

local function check_installed()
  for _, name in ipairs(vim.fn["jetpack#names"]()) do
    if not tb(vim.fn["jetpack#tap"](name)) then
      vim.fn["jetpack#sync"]()
      vim.cmd("source $MYVIMRC")
      break
    end
  end
end

local function load_lua_configs()
  for _, path in ipairs(vim.fn.glob(vim.fn.stdpath("config") .. "/lua/plugin/config/*.lua", 1, 1, 1)) do
    vim.cmd(string.format("luafile %s", vim.fn.fnameescape(path)))
  end
end

local plugin_list = {
  -- Plugin management {{
  { "tani/vim-jetpack", opt = 1 },
  { "lewis6991/impatient.nvim", as = "impatient", opt = 1 },
  { "4513ECHO/vim-readme-viewer", on = "VimEnter" },
  -- }}

  -- Essential libraries {{
  { "nvim-lua/plenary.nvim" },
  { "tami5/sqlite.lua" },
  { "tpope/vim-repeat" },
  { "antoinemadec/FixCursorHold.nvim" },
  { "MunifTanjim/nui.nvim" }, -- UI Framework
  { "kyazdani42/nvim-web-devicons" },
  { "nvim-lua/popup.nvim" },
  { "vim-denops/denops.vim" },
  { "rcarriga/nvim-notify", as = "notify", on = "VimEnter" },
  { "echasnovski/mini.nvim", branch = "stable", as = "mini" },
  -- }}

  -- Nvim-LSP {{
  { "neovim/nvim-lspconfig", as = "lspconfig", opt = true },
  { "williamboman/nvim-lsp-installer", opt = true },
  { "jose-elias-alvarez/null-ls.nvim", as = "null-ls", on = "VimEnter" },
  -- { "tamago324/nlsp-settings.nvim" },
  -- { "weilbith/nvim-lsp-smag" },
  { "lukas-reineke/lsp-format.nvim", as = "lsp-format" },

  -- UI
  { "onsails/lspkind.nvim", as = "lspkind" },
  { "folke/lsp-colors.nvim", as = "lsp-colors", on = "VimEnter" },
  { "j-hui/fidget.nvim", as = "fidget", on = "VimEnter" },
  -- { "tami5/lspsaga.nvim", as = "lspsaga", on = "VimEnter" },
  -- { "folke/trouble.nvim", as = "trouble", on = "VimEnter" },
  -- { "EthanJWright/toolwindow.nvim", as = "toolwindow", on = "VimEnter" },
  -- { "ray-x/lsp_signature.nvim" },
  -- }}

  -- specific language support
  -- { "HallerPatrick/py_lsp.nvim" },
  -- { "jose-elias-alvarez/typescript.nvim", as = "typescript" },

  -- }}

  -- Nvim-cmp {{
  { "hrsh7th/nvim-cmp", as = "cmp", on = "VimEnter" },
  { "hrsh7th/cmp-nvim-lsp", as = "cmp_nvim_lsp", opt = true },
  { "hrsh7th/cmp-nvim-lsp-document-symbol", opt = true },
  { "hrsh7th/cmp-nvim-lua", opt = true },
  { "hrsh7th/cmp-nvim-lsp-signature-help", opt = true },
  { "hrsh7th/cmp-buffer", opt = true },
  { "hrsh7th/cmp-path", opt = true },
  { "hrsh7th/cmp-cmdline", opt = true },
  { "hrsh7th/cmp-calc", opt = true },
  { "hrsh7th/cmp-omni", opt = true },
  { "hrsh7th/cmp-emoji", opt = true },
  { "lukas-reineke/cmp-rg", opt = true },
  { "lukas-reineke/cmp-under-comparator", opt = true },
  { "f3fora/cmp-spell", opt = true },
  { "ray-x/cmp-treesitter", opt = true },
  { "yutkat/cmp-mocword", opt = true },
  { "petertriho/cmp-git", as = "cmp_git", opt = true },
  -- { "uga-rosa/cmp-dictionary", opt = true },
  -- { "tzachar/cmp-tabnine", run = "./install.sh" },
  -- { "octaltree/cmp-look", opt = true },
  -- { "hrsh7th/cmp-copilot", opt = true },
  { "ryoppippi/cmp-copilot", branch = "dev/add-copilot-loaded-detecter", opt = true },
  { "hrsh7th/cmp-vsnip", opt = true, enabled = vim.g.enabled_snippet == "vsnip" },
  { "saadparwaiz1/cmp_luasnip", opt = true, enabled = vim.g.enabled_snippet == "luasnip" },
  -- }}

  -- ddc {{
  -- { "Shougo/ddc.vim",  as = "ddc"  },
  -- { "vim-denops/denops.vim" },
  -- { "Shougo/pum.vim" },
  -- { "Shougo/ddc-around" },
  -- { "Shougo/ddc-nvim-lsp" },
  -- { "Shougo/ddc-matcher_head" },
  -- { "Shougo/ddc-sorter_rank" },
  -- { "Shougo/ddc-converter_remove_overlap" },
  -- { "Shougo/ddc-rg" },
  -- { "Shougo/ddc-cmdline" },
  -- { "Shougo/ddc-cmdline-history" },
  -- { "Shougo/neco-vim" },
  -- { "tani/ddc-fuzzy" },
  -- { "matsui54/ddc-converter_truncate" },
  -- { "matsui54/denops-popup-preview.vim" },
  -- { "matsui54/denops-signature_help" },
  -- { "LumaKernel/ddc-tabnine" },
  -- { "LumaKernel/ddc-file" },
  -- { "matsui54/ddc-dictionary" },
  -- { "Shougo/ddc-omni" },
  -- { "gamoutatsumi/ddc-emoji" },
  -- { "delphinus/ddc-treesitter" },
  -- { "hrsh7th/vim-vsnip-integ" },
  -- }}

  -- AI {{
  { "github/copilot.vim", on = { "CursorHold", "InsertEnter" } },
  -- }}

  -- Nvim-treesitter {{
  { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
  { "nvim-treesitter/playground" },
  { "nvim-treesitter/nvim-tree-docs" },
  { "nvim-treesitter/nvim-treesitter-refactor" },
  { "yioneko/nvim-yati", as = "yati", on = "VimEnter" },
  { "JoosepAlviste/nvim-ts-context-commentstring" },
  { "vigoux/architext.nvim" },

  -- textobj
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "RRethy/nvim-treesitter-textsubjects" },
  { "David-Kunz/treesitter-unit" },
  -- { "mfussenegger/nvim-treehopper" },

  -- UI
  { "haringsrob/nvim_context_vt" },
  { "romgrk/nvim-treesitter-context" },
  { "stevearc/aerial.nvim", as = "aerial" },
  -- }}

  -- ColorScheme {{
  { "ulwlu/elly.vim" },
  { "navarasu/onedark.nvim", as = "onedark" },
  { "ray-x/starry.nvim", as = "starry" },
  { "rebelot/kanagawa.nvim", as = "kanagawa" },
  { "sainnhe/gruvbox-material", opt = true },
  -- { "marko-cerovac/material.nvim" },
  -- { "tribela/vim-transparent" },
  -- }}

  -- Heiglighting {{
  { "norcalli/nvim-colorizer.lua", as = "colorizer", on = "VimEnter" },
  { "folke/todo-comments.nvim", as = "todo-comments", on = "BufReadPost" },
  { "m-demare/hlargs.nvim" },
  { "RRethy/vim-illuminate", as = "illuminate" },
  -- { "t9md/vim-quickhl" }, -- heighlighting words on cursor position
  -- { "Pocco81/HighStr.nvim" }, -- highlight strings
  { "p00f/nvim-ts-rainbow" },
  -- }}

  -- StatusLine {{
  { "hoob3rt/lualine.nvim", as = "lualine", on = "VimEnter" },
  { "SmiteshP/nvim-gps" },
  -- { "feline-nvim/feline.nvim", on = "VimEnter", as = "feline" },
  -- }}

  -- Other UI Components {{
  { "jeffkreeftmeijer/vim-numbertoggle" },
  { "mvllow/modes.nvim", as = "modes", on = "ModeChanged" },
  -- mini.indentscope

  -- { "sidebar-nvim/sidebar.nvim", as = "sidebar", on = "VimEnter" },
  { "petertriho/nvim-scrollbar", as = "scrollbar", on = "VimEnter" },
  { "rainbowhxch/beacon.nvim", as = "beacon", on = "VimEnter" },
  -- }}

  -- Moving Cursor {{
  { "unblevable/quick-scope" },
  -- mini.jump
  -- mini.jump2d
  -- { "phaazon/hop.nvim", on = "VimEnter", as = "hop" },
  -- { "rhysd/clever-f.vim", { as = "clever-f", on = "VimEnter" } },
  { "yutkat/wb-only-current-line.nvim", on = "VimEnter" },
  { "deton/jasegment.vim", as = "jasegment", on = "VimEnter" }, -- Japanese word moving
  -- { "bkad/CamelCaseMotion" },
  -- }}

  -- File Management {{

  -- filer {{
  -- neo-tree
  { "nvim-neo-tree/neo-tree.nvim", as = "neo-tree", branch = "v2.x", on = "VimEnter" },

  -- fern {{
  -- { "lambdalisue/fern.vim", as = "fern" },
  -- { "lambdalisue/fern-git-status.vim" },
  -- { "lambdalisue/nerdfont.vim" },
  -- { "lambdalisue/fern-renderer-nerdfont.vim" },
  -- { "lambdalisue/glyph-palette.vim" },
  -- { "lambdalisue/fern-hijack.vim" },
  -- { "yuki-yano/fern-preview.vim" },
  -- { "LumaKernel/fern-mapping-fzf.vim" },
  -- }}

  -- vfiler {{
  -- { "obaland/vfiler.vim", on = "VimEnter", as = "vfiler" },
  -- { "obaland/vfiler-column-devicons", on = "VimEnter" },
  -- }}

  -- }}

  -- window
  { "tkmpypy/chowcho.nvim", as = "chowcho", on = "VimEnter" },
  { "kwkarlwang/bufresize.nvim", as = "bufresize", on = "VimEnter" },
  { "simeji/winresizer", on = "VimEnter" },

  -- buffer
  { "stevearc/stickybuf.nvim", as = "stickybuf", on = "VimEnter" },

  -- file format settings
  { "spywhere/detect-language.nvim", as = "detect-language", on = "VimEnter" },
  { "zsugabubus/crazy8.nvim" },
  { "lfilho/cosco.vim", on = "VimEnter" },

  -- MRU
  -- { "lambdalisue/mr.vim" },

  -- }}

  -- Editing {{

  -- textobj
  { "kana/vim-textobj-user" },
  { "osyo-manga/vim-textobj-blockwise", on = "VimEnter" },

  -- edit and insert
  { "thinca/vim-partedit" },

  -- brackets
  { "machakann/vim-sandwich", on = "VimEnter" },
  { "windwp/nvim-autopairs" },
  { "windwp/nvim-ts-autotag" },
  { "andymass/vim-matchup" },
  -- { "cohama/lexima.vim", as = "lexima" },

  -- comment
  -- commentout
  { "numToStr/Comment.nvim", as = "Comment" },
  -- comment generation
  { "s1n7ax/nvim-comment-frame" },
  { "LudoPinelli/comment-box.nvim" },
  { "danymat/neogen" },

  -- yank and paste
  { "gbprod/substitute.nvim", as = "substitute", on = "VimEnter" },
  -- { "gbprod/yanky.nvim", as = "yanky", on = "VimEnter" },
  { "hrsh7th/nvim-pasta", on = "VimEnter" },
  { "Rasukarusan/nvim-block-paste" },
  { "yuki-yano/deindent-yank.vim" },

  -- Select
  { "terryma/vim-expand-region", on = "<Plug>(expand_region_" },
  { "terryma/vim-multiple-cursors", on = "VimEnter" },
  { "kana/vim-niceblock", on = "VimEnter" },

  -- Swap Arguments
  { "mizlan/iswap.nvim", as = "iswap", on = { "ISwap", "ISwapWith" } },
  { "machakann/vim-swap", on = "VimEnter" },

  -- Join
  { "AckslD/nvim-trevJ.lua", as = "trevj", on = "VimEnter" },

  -- Adding,subtracting,change cases
  { "monaqa/dial.nvim", on = "VimEnter", as = "dial" },
  -- {'monaqa/dps-dial.vim',on= 'VimEnter', as='dps-dial'},
  { "deris/vim-rengbang", on = "VimEnter" },
  -- { "mopp/vim-operator-convert-case" },

  -- }}

  -- Builtin Enhancements {{
  -- Quickfix
  { "thinca/vim-quickrun" },
  { "thinca/vim-qfreplace" },
  { "itchyny/vim-qfedit" },
  { "kevinhwang91/nvim-bqf" },
  { "gabrielpoca/replacer.nvim" },

  -- Undo
  { "simnalamburt/vim-mundo", on = "MundoShow" },

  -- Diff
  { "AndrewRadev/linediff.vim" },

  -- Macro
  { "zdcthomas/medit", on = "<Plug>MEdit" },

  -- Register
  { "tversteeg/registers.nvim", branch = "main" },

  -- Mark
  { "chentoast/marks.nvim", as = "marks", on = "VimEnter" },

  -- Fold
  { "lambdalisue/readablefold.vim" },

  -- Manual
  { "thinca/vim-ref", on = "VimEnter" },
  { "folke/which-key.nvim", as = "which-key", on = "VimEnter" },

  -- Session
  -- {'rmagatti/auto-session'},

  -- Save
  { "Pocco81/AutoSave.nvim", on = "VimEnter", as = "autosave" },

  -- SpellCorrect
  -- { "Pocco81/AbbrevMan.nvim" },

  -- Command
  { "wsdjeg/vim-fetch" },
  { "jghauser/mkdir.nvim" },
  { "sQVe/sort.nvim", as = "sort" },
  { "tyru/capture.vim" },

  -- Terminal
  { "akinsho/toggleterm.nvim", as = "toggleterm", on = "VimEnter" },

  -- Job running
  { "skywind3000/asyncrun.vim", on = "VimEnter" },

  -- }}

  -- New Features {{

  -- Browser
  { "tyru/open-browser.vim", on = "CmdlineEnter" },
  { "tyru/open-browser-github.vim", on = "CmdlineEnter" },

  -- Screenshot
  { "segeljakt/vim-silicon", on = "VimEnter" },

  -- Template
  { "mattn/vim-sonictemplate", on = "CmdlineEnter" },

  -- Color Management
  { "max397574/colortils.nvim", as = "colortils", on = "VimEnter" },

  -- Git support{{
  -- client
  { "TimUntersberger/neogit", as = "neogit", on = "Neogit" },
  { "lambdalisue/gin.vim", as = "gin", on = "VimEnter" },
  -- { "tanvirtin/vgit.nvim", as = "vgit", on = "VimEnter" },

  -- git command assistant
  { "rhysd/committia.vim" },
  { "hotwatermorning/auto-git-diff", on = "VimEnter" },

  -- show messages
  { "lewis6991/gitsigns.nvim", as = "gitsigns", on = "VimEnter" },
  { "rhysd/git-messenger.vim" },

  { "akinsho/git-conflict.nvim", as = "git-conflict", on = "VimEnter" },
  { "sindrets/diffview.nvim", as = "diffview", on = "VimEnter" },
  { "yutkat/convert-git-url.nvim", as = "convert-git-url", on = "ConvertGitUrl" },

  -- github
  { "pwntester/octo.nvim", as = "octo", on = "VimEnter" },
  { "skanehira/denops-gh.vim", on = "VimEnter" },

  -- }}

  -- Docker {{
  { "skanehira/denops-docker.vim", on = "VimEnter" },
  -- }}

  -- }}

  -- Search {{
  { "haya14busa/vim-asterisk", as = "asterisk", on = "<Plug>(asterisk-" },
  { "hrsh7th/vim-searchx", as = "searchx" },
  { "monaqa/modesearch.vim", as = "modesearch", on = "VimEnter" },
  { "kevinhwang91/nvim-hlslens", as = "hlslens" },
  -- }}

  -- Fuzzy Finder {{
  -- Telescope {{
  { "nvim-telescope/telescope.nvim", as = "telescope", on = "VimEnter" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "nvim-telescope/telescope-file-browser.nvim" },
  { "nvim-telescope/telescope-frecency.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
  { "nvim-telescope/telescope-media-files.nvim" },
  { "nvim-telescope/telescope-symbols.nvim" },
  { "nvim-telescope/telescope-ghq.nvim" },
  { "nvim-telescope/telescope-github.nvim" },
  { "LinArcX/telescope-env.nvim" },
  { "crispgm/telescope-heading.nvim" },
  { "LinArcX/telescope-changes.nvim" },
  { "tknightz/telescope-termfinder.nvim" },
  { "benfowler/telescope-luasnip.nvim", enabled = vim.g.enabled_snippet == "luasnip" },
  -- }}
  -- }}

  -- Snippets {{
  { "hrsh7th/vim-vsnip", on = "VimEnter", enabled = (vim.g.enabled_snippet == "vsnip") },
  { "L3MON4D3/LuaSnip", as = "luasnip", enabled = (vim.g.enabled_snippet == "luasnip") },

  -- utils
  { "kevinhwang91/nvim-hclipboard", as = "hclipboard", on = "VimEnter" }, -- prevent polluting clipboard
  -- { "smjonas/snippet-converter.nvim" },

  -- snippets collection {{
  { "craigmac/vim-vsnip-snippets" },
  { "honza/vim-snippets" },
  { "rafamadriz/friendly-snippets" },
  -- }}

  -- language specific snippets {{
  -- go
  { "golang/vscode-go" },
  -- python
  { "cstrap/flask-snippets" },
  { "cstrap/python-snippets" },
  -- web
  { "fivethree-team/vscode-svelte-snippets" },
  -- { "stordahl/sveltekit-snippets" },
  { "xabikos/vscode-javascript" },
  -- }}
  -- }}

  -- Language specific plugins {{
  -- javascript
  { "vuki656/package-info.nvim", as = "package-info", on = "PackageInfo" },
  { "bennypowers/nvim-regexplainer", as = "regexplainer", on = "VimEnter" },
  -- markdown
  { "previm/previm" },
  { "dhruvasagar/vim-table-mode", on = "VimEnter" },
  -- sql
  { "jsborjesson/vim-uppercase-sql" },
  -- lua
  { "milisims/nvim-luaref" },
  -- log
  { "mtdl9/vim-log-highlighting" },
  -- csv
  { "chen244/csv-tools.lua", as = "csvtools" },
  -- rust
  { "shurizzle/inlay-hints.nvim", as = "inlay-hints", on = "VimEnter" },
  -- go
  { "ray-x/go.nvim", as = "go" },
  -- }}

  -- Debug {{
  { "sentriz/vim-print-debug" },
  -- }}

  -- Task Runner{{
  { "yutkat/taskrun.nvim", as = "taskrun", on = "VimEnter" },
  -- { "michaelb/sniprun", run = "bash ./install.sh", on = "CmdlineEnter" },
  -- }}

  -- Neovim
  { "wadackel/nvim-syntax-info", on = "VimEnter" },
  { "hkupty/iron.nvim", as = "iron", on = "VimEnter" },
  -- }}

  -- Something fun {{
  { "ryoppippi/bad-apple.vim", branch = "main" },
  -- }}
}

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    check_installed()
  end,
})

ensure_jetpack()
load_plugins(plugin_list)
load_lua_configs()
