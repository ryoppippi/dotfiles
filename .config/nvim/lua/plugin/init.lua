local tb = require("utils").toboolean

-- check if jetpack is installed
local status, _ = require("utils.plugin").load("vim-jetpack")
if not status then
  vim.api.nvim_exec(
    [[
        let dir = expand(stdpath('data') ..'/site/pack/jetpack/opt/vim-jetpack')
        if !isdirectory(dir)
          let url = 'https://github.com/tani/vim-jetpack'
          silent execute printf('!git clone --depth 1 %s %s', url, dir)
          silent execute 'ln -sf ~/.local/share/nvim/site/pack/jetpack/{src,opt}/vim-jetpack'
        endif
        packadd vim-jetpack
      ]],
    true
  )
end

-- init jetpack
local jp = require("jetpack")
jp.init({
  copy_method = "symlink",
  optimization = 1,
})
-- vim.g.enabled_snippet = "vsnip"
vim.g.enabled_snippet = "luasnip"

local plugin_list = {
  -- Plugin management {{
  { "tani/vim-jetpack", opt = true },
  { "lewis6991/impatient.nvim", as = "impatient", opt = true },
  { "4513ECHO/vim-readme-viewer", on = "User VimLoaded" },
  -- }}

  -- Essential libraries {{
  { "nvim-lua/plenary.nvim" },
  { "tami5/sqlite.lua" },
  { "tpope/vim-repeat" },
  { "monaqa/peridot.vim", as = "peridot" },
  { "antoinemadec/FixCursorHold.nvim" },
  { "MunifTanjim/nui.nvim" }, -- UI Framework
  { "kyazdani42/nvim-web-devicons" },
  { "nvim-lua/popup.nvim" },
  { "ray-x/guihua.lua" },
  { "vim-denops/denops.vim" },
  { "rcarriga/nvim-notify", as = "notify", on = "User VimLoaded" },
  { "echasnovski/mini.nvim", branch = "stable", as = "mini" },
  -- }}

  -- StatusLine {{
  { "feline-nvim/feline.nvim", as = "feline", on = "VimEnter" },
  -- { "SmiteshP/nvim-gps" },
  { "SmiteshP/nvim-navic" },
  -- { "hoob3rt/lualine.nvim", as = "lualine", on="VimEnter" },
  -- }}

  -- Other UI Components {{
  { "jeffkreeftmeijer/vim-numbertoggle" },
  { "mvllow/modes.nvim", as = "modes", on = "ModeChanged" },
  -- mini.indentscope

  -- { "sidebar-nvim/sidebar.nvim", as = "sidebar", on = "User VimLoaded" },
  { "petertriho/nvim-scrollbar", as = "scrollbar", on = "User VimLoaded" },
  { "rainbowhxch/beacon.nvim", as = "beacon", on = "User VimLoaded" },
  -- }}

  -- Moving Cursor {{
  { "unblevable/quick-scope" },
  -- mini.jump
  -- mini.jump2d
  -- { "phaazon/hop.nvim", on = "User VimLoaded", as = "hop" },
  -- { "rhysd/clever-f.vim", { as = "clever-f", on = "User VimLoaded" } },
  { "yutkat/wb-only-current-line.nvim", on = "User VimLoaded" },
  { "deton/jasegment.vim", as = "jasegment", on = "User VimLoaded" }, -- Japanese word moving
  -- { "bkad/CamelCaseMotion" },
  -- }}

  -- File Management {{

  -- filer {{
  -- neo-tree {{
  { "nvim-neo-tree/neo-tree.nvim", as = "neo-tree", branch = "v2.x", on = "User VimLoaded" },
  -- }}

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

  -- lir {{
  -- { "tamago324/lir.nvim", as = "lir" },
  -- { "tamago324/lir-git-status.nvim" },
  -- }}

  -- }}

  -- window
  { "tkmpypy/chowcho.nvim", as = "chowcho", on = "User VimLoaded" },
  { "kwkarlwang/bufresize.nvim", as = "bufresize", on = "User VimLoaded" },
  { "simeji/winresizer", on = "User VimLoaded" },

  -- buffer
  { "stevearc/stickybuf.nvim", as = "stickybuf", on = "User VimLoaded" },
  { "famiu/bufdelete.nvim", as = "bufdelete" },

  -- project
  { "ahmedkhalf/project.nvim", as = "project_nvim" },
  -- { "mattn/vim-findroot" },

  -- file format settings
  { "spywhere/detect-language.nvim", as = "detect-language", on = "User VimLoaded" },
  -- { "zsugabubus/crazy8.nvim" },
  { "lfilho/cosco.vim", on = "User VimLoaded" },
  { "nmac427/guess-indent.nvim", as = "guess-indent" },

  -- MRU
  -- { "lambdalisue/mr.vim" },

  -- }}

  -- Editing {{

  -- textobj
  { "kana/vim-textobj-user" },
  { "osyo-manga/vim-textobj-blockwise", on = "User VimLoaded" },

  -- edit and insert
  { "thinca/vim-partedit", on = "Partedit" },

  -- brackets and parentheses
  { "machakann/vim-sandwich", on = "User VimLoaded" },
  { "andymass/vim-matchup", on = "User VimLoaded" },
  { "windwp/nvim-autopairs", on = "User VimLoaded" },
  { "windwp/nvim-ts-autotag", on = "User VimLoaded" },
  { "RRethy/nvim-treesitter-endwise", on = "User VimLoaded" },

  -- { "cohama/lexima.vim", as = "lexima" },

  -- comment
  -- commentout
  { "numToStr/Comment.nvim", as = "Comment", on = "User VimLoaded" },
  -- comment generation
  { "s1n7ax/nvim-comment-frame" },
  { "LudoPinelli/comment-box.nvim" },
  { "danymat/neogen" },

  -- yank and paste
  { "gbprod/substitute.nvim", as = "substitute", on = "User VimLoaded" },
  -- { "gbprod/yanky.nvim", as = "yanky", on = "User VimLoaded" },
  { "hrsh7th/nvim-pasta", on = "User VimLoaded" },
  { "Rasukarusan/nvim-block-paste" },
  { "yuki-yano/deindent-yank.vim" },
  -- { "AckslD/nvim-anywise-reg.lua", as = "nvim-anywise-reg", on = "User VimLoaded" },

  -- Select
  { "terryma/vim-expand-region", on = "<Plug>(expand_region_" },
  { "terryma/vim-multiple-cursors", on = "User VimLoaded" },
  { "kana/vim-niceblock", on = "User VimLoaded" },

  -- Swap Arguments
  { "mizlan/iswap.nvim", as = "iswap", on = { "ISwap", "ISwapWith" } },
  { "machakann/vim-swap", on = "User VimLoaded" },

  -- Join
  { "AckslD/nvim-trevJ.lua", as = "trevj", on = "User VimLoaded" },

  -- Adding,subtracting,change cases
  { "monaqa/dial.nvim", as = "dial", on = "User VimLoaded" },
  -- {'monaqa/dps-dial.vim',on= 'User VimLoaded', as='dps-dial'},
  { "deris/vim-rengbang" },
  -- { "johmsalas/text-case.nvim", as = "textcase", on = "User VimLoaded" },
  -- { "mopp/vim-operator-convert-case" },

  -- }}

  -- Builtin Enhancements {{
  -- Quickfix
  { "thinca/vim-quickrun" },
  { "thinca/vim-qfreplace", on = "Qfreplace" },
  { "itchyny/vim-qfedit" },
  { "kevinhwang91/nvim-bqf" },
  -- { "gabrielpoca/replacer.nvim" },

  -- Undo
  { "simnalamburt/vim-mundo", on = "MundoShow" },

  -- Diff
  { "AndrewRadev/linediff.vim" },

  -- Macro
  { "zdcthomas/medit", on = "<Plug>MEdit" },

  -- Register
  { "tversteeg/registers.nvim", branch = "main" },

  -- Mark
  { "chentoast/marks.nvim", as = "marks", on = "User VimLoaded" },

  -- Fold
  { "lambdalisue/readablefold.vim" },

  -- Manual
  { "thinca/vim-ref", on = "User VimLoaded" },
  { "folke/which-key.nvim", as = "which-key", on = "User VimLoaded" },
  { "michaelb/vim-tips", on = "User VimLoaded" },

  -- Session
  -- {'rmagatti/auto-session'},

  -- Save
  { "Pocco81/AutoSave.nvim", as = "autosave", on = "User VimLoaded" },

  -- SpellCorrect
  -- { "Pocco81/AbbrevMan.nvim" },
  { "lewis6991/spellsitter.nvim", as = "spellsitter", on = "User VimLoaded" },

  -- Command
  { "wsdjeg/vim-fetch" },
  { "jghauser/mkdir.nvim" },
  { "sQVe/sort.nvim", as = "sort" },
  { "tyru/capture.vim" },

  -- Terminal
  { "akinsho/toggleterm.nvim", as = "toggleterm", on = "User VimLoaded" },

  -- Job running
  { "skywind3000/asyncrun.vim", on = "User VimLoaded" },

  -- }}

  -- New Features {{

  -- Browser
  { "tyru/open-browser.vim", on = "User VimLoaded" },
  { "tyru/open-browser-github.vim", on = "User VimLoaded" },
  { "tyru/open-browser-unicode.vim", on = "User VimLoaded" },

  -- Screenshot
  { "segeljakt/vim-silicon", on = "User VimLoaded" },

  -- Template
  { "mattn/vim-sonictemplate", on = "CmdlineEnter" },

  -- Color Management
  { "max397574/colortils.nvim", as = "colortils", on = "User VimLoaded" },

  -- Git support{{
  -- client
  { "TimUntersberger/neogit", as = "neogit", on = "Neogit" },
  { "lambdalisue/gin.vim", as = "gin", on = "User VimLoaded" },
  -- { "tanvirtin/vgit.nvim", as = "vgit", on = "User VimLoaded" },

  -- git command assistant
  { "rhysd/committia.vim" },
  { "hotwatermorning/auto-git-diff", on = "User VimLoaded" },

  -- show messages
  { "lewis6991/gitsigns.nvim", as = "gitsigns", on = "User VimLoaded" },
  { "rhysd/git-messenger.vim" },

  { "akinsho/git-conflict.nvim", as = "git-conflict", on = "User VimLoaded" },
  { "sindrets/diffview.nvim", as = "diffview", on = "User VimLoaded" },
  { "yutkat/convert-git-url.nvim", as = "convert-git-url", on = "ConvertGitUrl" },

  -- Github
  { "pwntester/octo.nvim", as = "octo", on = "User VimLoaded" },
  { "skanehira/denops-gh.vim", on = "User VimLoaded" },

  -- }}

  -- Docker {{
  { "skanehira/denops-docker.vim", on = "User VimLoaded" },
  -- }}

  -- REST {{
  { "NTBBloodbath/rest.nvim", as = "rest-nvim", on = "User VimLoaded" },
  -- }}

  -- GraphAPI {{
  { "skanehira/denops-graphql.vim", as = "denops-graphql", on = "User VimLoaded" },
  -- }}

  -- }}

  -- Search {{
  { "haya14busa/vim-asterisk", as = "asterisk", on = "<Plug>(asterisk-" },
  { "hrsh7th/vim-searchx", as = "searchx" },
  { "monaqa/modesearch.vim", as = "modesearch", on = "User VimLoaded" },
  { "kevinhwang91/nvim-hlslens", as = "hlslens" },
  -- }}

  -- Rename {{
  { "smjonas/inc-rename.nvim", as = "inc_rename", on = "User VimLoaded" },
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

  -- Languages
  -- Nvim-LSP {{
  { "neovim/nvim-lspconfig", as = "lspconfig", opt = true },
  { "williamboman/nvim-lsp-installer" },
  { "jose-elias-alvarez/null-ls.nvim", as = "null-ls", on = "User VimLoaded" },
  { "lukas-reineke/lsp-format.nvim", as = "lsp-format" },

  -- UI
  { "onsails/lspkind.nvim", as = "lspkind" },
  { "folke/lsp-colors.nvim", as = "lsp-colors", on = "User VimLoaded" },
  { "j-hui/fidget.nvim", as = "fidget", on = "User VimLoaded" },
  { "folke/trouble.nvim", as = "trouble", on = "User VimLoaded" },
  -- { "tami5/lspsaga.nvim", as = "lspsaga", on = "User VimLoaded" },
  -- { "folke/trouble.nvim", as = "trouble", on = "User VimLoaded" },
  -- { "EthanJWright/toolwindow.nvim", as = "toolwindow", on = "User VimLoaded" },
  -- { "ray-x/lsp_signature.nvim" },
  -- }}
  -- }}

  -- Nvim-cmp {{
  { "hrsh7th/nvim-cmp", as = "cmp", on = "User VimLoaded" },
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

  -- Nvim-treesitter {{
  { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
  { "yioneko/nvim-yati", as = "yati", on = "User VimLoaded" },
  { "JoosepAlviste/nvim-ts-context-commentstring", on = "User VimLoaded" },
  -- { "nvim-treesitter/nvim-tree-docs" },
  -- { "vigoux/architext.nvim" },
  -- { "nvim-treesitter/nvim-treesitter-refactor" },

  -- textobj
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "RRethy/nvim-treesitter-textsubjects" },
  { "David-Kunz/treesitter-unit" },
  -- { "mfussenegger/nvim-treehopper" },

  -- UI
  { "haringsrob/nvim_context_vt", on = "User VimLoaded" },
  { "romgrk/nvim-treesitter-context", on = "User VimLoaded" },
  { "stevearc/aerial.nvim", as = "aerial", on = "User VimLoaded" },
  { "nvim-treesitter/playground", on = "User VimLoaded" },
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
  { "norcalli/nvim-colorizer.lua", as = "colorizer", on = "User VimLoaded" },
  { "folke/todo-comments.nvim", as = "todo-comments", on = "BufReadPost" },
  { "m-demare/hlargs.nvim", as = "hlargs" },
  { "p00f/nvim-ts-rainbow" },
  { "RRethy/vim-illuminate", as = "illuminate" },
  -- { "t9md/vim-quickhl" }, -- heighlighting words on cursor position
  -- { "Pocco81/HighStr.nvim" }, -- highlight strings
  -- }}

  -- Snippets {{
  { "hrsh7th/vim-vsnip", on = "User VimLoaded", enabled = (vim.g.enabled_snippet == "vsnip") },
  { "L3MON4D3/LuaSnip", as = "luasnip", enabled = (vim.g.enabled_snippet == "luasnip") },

  -- utils
  { "kevinhwang91/nvim-hclipboard", as = "hclipboard", on = "User VimLoaded" }, -- prevent polluting clipboard
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
  { "bennypowers/nvim-regexplainer", as = "regexplainer", on = "User VimLoaded" },
  -- typescript
  { "jose-elias-alvarez/typescript.nvim", as = "typescript" },
  { "dhruvasagar/vim-table-mode", on = "User VimLoaded" },
  -- sql
  { "jsborjesson/vim-uppercase-sql" },
  -- lua
  { "milisims/nvim-luaref" },
  { "folke/lua-dev.nvim" },
  -- rust
  -- { "shurizzle/inlay-hints.nvim", as = "inlay-hints", on = "User VimLoaded" },
  { "simrat39/rust-tools.nvim", as = "rust-tools", opt = true },
  -- go
  { "ray-x/go.nvim", as = "go", opt = true },
  -- }}
  -- markdown
  { "previm/previm", ft = { "markdown" } },
  { "iamcco/markdown-preview.nvim", ft = { "markdown" }, run = ":call mkdp#util#install()" },
  -- { "SidOfc/mkdx", ft = { "markdown" } },
  -- log
  { "mtdl9/vim-log-highlighting" },
  -- csv
  -- { "chen244/csv-tools.lua" },
  { "mechatroner/rainbow_csv", ft = { "csv" } },
  -- json
  { "b0o/schemastore.nvim", as = "schemastore" },

  -- AI {{
  { "github/copilot.vim", as = "copilot", on = { "CursorHold", "InsertEnter" } },
  -- }}

  -- Debug {{
  { "sentriz/vim-print-debug" },
  -- }}

  -- Test {{
  { "nvim-neotest/neotest", on = "User VimLoaded" },
  -- }}

  -- Task Runner{{
  { "yutkat/taskrun.nvim", as = "taskrun", on = "User VimLoaded" },
  -- { "michaelb/sniprun", run = "bash ./install.sh", on = "CmdlineEnter" },
  -- }}

  -- Neovim
  { "wadackel/nvim-syntax-info", on = "User VimLoaded" },
  { "hkupty/iron.nvim", as = "iron", on = "User VimLoaded" },
  -- }}

  -- Something fun {{
  { "ryoppippi/bad-apple.vim", branch = "main" },
  -- }}
}

-- load plugins
jp.startup(function(use)
  for _, plugin in ipairs(plugin_list) do
    local enabled = plugin.enabled
    if enabled ~= false then
      use(plugin)
    end
  end
end)

-- load plugin configs
for _, path in ipairs(vim.fn.glob(vim.fn.stdpath("config") .. "/lua/plugin/config/*.lua", 1, 1, 1)) do
  local plugin_name = vim.fn.fnamemodify(path, ":t:r")
  if jp.tap(plugin_name) then
    vim.cmd("luafile " .. path)
  end
end

-- check if all plugins are installed
vim.api.nvim_create_autocmd("User VimLoaded", {
  callback = function()
    for _, name in ipairs(jp.names()) do
      if not tb(jp.tap(name)) then
        jp.sync()
        vim.cmd("source $MYVIMRC")
        break
      end
    end
  end,
})
