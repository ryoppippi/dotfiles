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
vim.g.enabled_snippet = "vsnip"
-- vim.g.enabled_snippet = "luasnip"

local plugin_list = {
  -- Plugin management {{
  { "tani/vim-jetpack", opt = true },
  { "lewis6991/impatient.nvim", opt = true },
  { "4513ECHO/vim-readme-viewer", on = "User VimLoaded" },
  { "tweekmonster/startuptime.vim", on = "User VimLoaded" },
  -- }}

  -- Essential libraries {{
  { "nvim-lua/plenary.nvim" },
  { "tami5/sqlite.lua" },
  { "tpope/vim-repeat" },
  { "monaqa/peridot.vim" },
  { "antoinemadec/FixCursorHold.nvim" },
  { "MunifTanjim/nui.nvim" },
  { "kyazdani42/nvim-web-devicons" },
  { "nvim-lua/popup.nvim" },
  { "ray-x/guihua.lua" },
  { "vim-denops/denops.vim" },
  { "rcarriga/nvim-notify", on = "User VimLoaded" },
  { "echasnovski/mini.nvim", branch = "stable" },
  -- }}

  -- StatusLine {{
  { "feline-nvim/feline.nvim", on = "VimEnter" },
  -- { "SmiteshP/nvim-gps" },
  { "SmiteshP/nvim-navic" },
  -- { "hoob3rt/lualine.nvim", on="VimEnter" },
  -- }}

  -- Other UI Components {{
  { "jeffkreeftmeijer/vim-numbertoggle" },
  { "mvllow/modes.nvim", on = "ModeChanged" },
  -- mini.indentscope

  { "petertriho/nvim-scrollbar", on = "User VimLoaded" },
  -- { "sidebar-nvim/sidebar.nvim", on = "User VimLoaded" },
  -- { "rainbowhxch/beacon.nvim", on = "User VimLoaded" },
  -- }}

  -- Moving Cursor {{
  { "unblevable/quick-scope" },
  -- mini.jump
  -- mini.jump2d
  -- { "phaazon/hop.nvim", on = "User VimLoaded"},
  -- { "rhysd/clever-f.vim", { on = "User VimLoaded" } },
  { "yutkat/wb-only-current-line.nvim", on = "User VimLoaded" },
  { "deton/jasegment.vim", on = "User VimLoaded" }, -- Japanese word moving
  -- { "bkad/CamelCaseMotion" },
  -- }}

  -- File Management {{

  -- filer {{
  -- neo-tree {{
  { "nvim-neo-tree/neo-tree.nvim", branch = "v2.x", on = "User VimLoaded" },
  -- }}

  -- fern {{
  -- { "lambdalisue/fern.vim" },
  -- { "lambdalisue/fern-git-status.vim" },
  -- { "lambdalisue/nerdfont.vim" },
  -- { "lambdalisue/fern-renderer-nerdfont.vim" },
  -- { "lambdalisue/glyph-palette.vim" },
  -- { "lambdalisue/fern-hijack.vim" },
  -- { "yuki-yano/fern-preview.vim" },
  -- { "LumaKernel/fern-mapping-fzf.vim" },
  -- }}

  -- lir {{
  -- { "tamago324/lir.nvim" },
  -- { "tamago324/lir-git-status.nvim" },
  -- }}

  -- }}

  -- window
  { "tkmpypy/chowcho.nvim", on = "User VimLoaded" },
  { "kwkarlwang/bufresize.nvim", on = "User VimLoaded" },
  { "simeji/winresizer", on = "User VimLoaded" },

  -- buffer
  { "stevearc/stickybuf.nvim", on = "User VimLoaded" },
  { "famiu/bufdelete.nvim" },

  -- project
  -- { "ahmedkhalf/project.nvim", as = "project_nvim" },
  -- { "mattn/vim-findroot" },

  -- file format settings
  { "spywhere/detect-language.nvim", on = "User VimLoaded" },
  -- { "zsugabubus/crazy8.nvim" },
  { "lfilho/cosco.vim", on = "User VimLoaded" },
  { "nmac427/guess-indent.nvim" },

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
  { "andymass/vim-matchup" },
  { "windwp/nvim-autopairs", on = "User VimLoaded" },
  { "windwp/nvim-ts-autotag", on = "User VimLoaded" },
  { "RRethy/nvim-treesitter-endwise", on = "User VimLoaded" },
  { "abecodes/tabout.nvim" },

  -- { "cohama/lexima.vim" },

  -- comment
  -- commentout
  { "numToStr/Comment.nvim", on = "User VimLoaded" },
  -- comment generation
  { "s1n7ax/nvim-comment-frame" },
  { "LudoPinelli/comment-box.nvim" },
  { "danymat/neogen" },

  -- yank and paste
  { "gbprod/substitute.nvim", on = "User VimLoaded" },
  -- { "gbprod/yanky.nvim", on = "User VimLoaded" },
  { "hrsh7th/nvim-pasta", on = "User VimLoaded" },
  { "Rasukarusan/nvim-block-paste" },
  { "yuki-yano/deindent-yank.vim" },
  -- { "AckslD/nvim-anywise-reg.lua", on = "User VimLoaded" },

  -- Select
  { "terryma/vim-expand-region", on = "<Plug>(expand_region_" },
  { "terryma/vim-multiple-cursors", on = "User VimLoaded" },
  { "kana/vim-niceblock", on = "User VimLoaded" },

  -- Swap Arguments
  { "mizlan/iswap.nvim", on = { "ISwap", "ISwapWith" } },
  { "machakann/vim-swap", on = "User VimLoaded" },

  -- Join
  { "AckslD/nvim-trevJ.lua", on = "User VimLoaded" },

  -- Adding,subtracting,change cases
  { "monaqa/dial.nvim", on = "User VimLoaded" },
  -- {'monaqa/dps-dial.vim',on= 'User VimLoaded' },
  { "deris/vim-rengbang" },
  -- { "johmsalas/text-case.nvim", on = "User VimLoaded" },
  -- { "mopp/vim-operator-convert-case" },

  -- }}

  -- Builtin Enhancements {{
  -- Quickfix
  { "thinca/vim-quickrun" },
  { "thinca/vim-qfreplace", on = "Qfreplace" },
  { "itchyny/vim-qfedit" },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
  -- { "gabrielpoca/replacer.nvim" },

  -- Undo
  { "simnalamburt/vim-mundo", on = "MundoShow" },

  -- Diff
  { "AndrewRadev/linediff.vim" },

  -- Macro
  { "zdcthomas/medit", on = "<Plug>MEdit" },

  -- Register
  { "tversteeg/registers.nvim", branch = "main", on = "User VimLoaded" },

  -- Mark
  { "chentoast/marks.nvim", on = "User VimLoaded" },

  -- Fold
  -- { "lambdalisue/readablefold.vim" },
  { "monaqa/pretty-fold.nvim", branch = "for_stable_neovim" },
  -- { "monaqa/pretty-fold.nvim", branch = "for_stable_neovim" },

  -- Manual
  { "thinca/vim-ref", on = "User VimLoaded" },
  { "folke/which-key.nvim", on = "User VimLoaded" },
  { "michaelb/vim-tips", on = "User VimLoaded" },

  -- Session
  -- {'rmagatti/auto-session'},

  -- Save
  -- { "Pocco81/AutoSave.nvim", as = "autosave", on = "User VimLoaded" },

  -- SpellCorrect
  -- { "Pocco81/AbbrevMan.nvim" },
  { "lewis6991/spellsitter.nvim", on = "User VimLoaded" },

  -- Command
  { "wsdjeg/vim-fetch" },
  { "jghauser/mkdir.nvim" },
  { "sQVe/sort.nvim" },
  { "tyru/capture.vim" },

  -- Terminal
  { "akinsho/toggleterm.nvim", on = "User VimLoaded" },

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
  { "max397574/colortils.nvim", on = "User VimLoaded" },

  -- Git support{{
  -- client
  { "TimUntersberger/neogit", on = "Neogit" },
  { "lambdalisue/gin.vim", on = "User VimLoaded" },
  -- { "tanvirtin/vgit.nvim", on = "User VimLoaded" },

  -- git command assistant
  { "rhysd/committia.vim" },
  { "hotwatermorning/auto-git-diff", on = "User VimLoaded" },

  -- show messages
  { "lewis6991/gitsigns.nvim" },
  { "rhysd/git-messenger.vim", on = { "GitMessenger", "GitMessengerClose", "<Plug>(git-messenger" } },

  { "akinsho/git-conflict.nvim", on = "User VimLoaded" },
  { "sindrets/diffview.nvim", on = "User VimLoaded" },
  { "yutkat/convert-git-url.nvim", on = "ConvertGitUrl" },

  -- Github
  { "pwntester/octo.nvim", on = "User VimLoaded" },
  { "skanehira/denops-gh.vim", on = "User VimLoaded" },

  -- }}

  -- Docker {{
  { "skanehira/denops-docker.vim", on = "User VimLoaded" },
  -- }}

  -- REST {{
  { "NTBBloodbath/rest.nvim", on = "User VimLoaded" },
  -- }}

  -- GraphAPI {{
  { "skanehira/denops-graphql.vim", on = "User VimLoaded" },
  -- }}

  -- }}

  -- Search {{
  { "haya14busa/vim-asterisk", on = "<Plug>(asterisk-" },
  { "hrsh7th/vim-searchx" },
  { "monaqa/modesearch.vim", on = "User VimLoaded" },
  { "kevinhwang91/nvim-hlslens", as = "hlslens" },
  -- }}

  -- Rename {{
  { "smjonas/inc-rename.nvim", as = "inc_rename", on = "User VimLoaded" },
  -- }}

  -- Fuzzy Finder {{
  -- Telescope {{
  { "nvim-telescope/telescope.nvim", on = "VimEnter" },
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
  { "williamboman/nvim-lsp-installer", opt = true },
  { "jose-elias-alvarez/null-ls.nvim", on = "User VimLoaded" },
  { "lukas-reineke/lsp-format.nvim" },

  -- UI
  { "onsails/lspkind.nvim" },
  { "folke/lsp-colors.nvim", on = "User VimLoaded" },
  { "j-hui/fidget.nvim", on = "User VimLoaded" },
  { "folke/trouble.nvim", on = "User VimLoaded" },
  -- { "tami5/lspsaga.nvim", on = "User VimLoaded" },
  -- { "folke/trouble.nvim", on = "User VimLoaded" },
  -- { "EthanJWright/toolwindow.nvim", on = "User VimLoaded" },
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
  -- { "Shougo/ddc.vim" },
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
  { "yioneko/nvim-yati", on = "User VimLoaded" },
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
  -- { "nvim-treesitter/playground", on = "User VimLoaded" },
  -- { "stevearc/aerial.nvim", on = "User VimLoaded" },
  -- }}

  -- ColorScheme {{
  { "ulwlu/elly.vim" },
  { "navarasu/onedark.nvim" },
  { "ray-x/starry.nvim" },
  { "rebelot/kanagawa.nvim" },
  { "sainnhe/gruvbox-material", opt = true },
  -- { "marko-cerovac/material.nvim" },
  -- { "tribela/vim-transparent" },
  -- }}

  -- Heiglighting {{
  { "norcalli/nvim-colorizer.lua", on = "User VimLoaded" },
  { "folke/todo-comments.nvim", on = "BufReadPost" },
  { "m-demare/hlargs.nvim" },
  { "p00f/nvim-ts-rainbow", on = "User VimLoaded" },
  { "RRethy/vim-illuminate", as = "illuminate" },
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
  { "vuki656/package-info.nvim", on = "PackageInfo" },
  { "bennypowers/nvim-regexplainer", as = "regexplainer", on = "User VimLoaded" },
  -- typescript
  { "jose-elias-alvarez/typescript.nvim" },
  { "dhruvasagar/vim-table-mode", on = "User VimLoaded" },
  -- sql
  { "jsborjesson/vim-uppercase-sql" },
  -- lua
  { "milisims/nvim-luaref" },
  { "folke/lua-dev.nvim" },
  -- rust
  -- { "shurizzle/inlay-hints.nvim",  on = "User VimLoaded" },
  { "simrat39/rust-tools.nvim" },
  -- go
  { "ray-x/go.nvim" },
  -- }}
  -- markdown
  -- { "previm/previm", ft = { "markdown", "pandoc.markdown", "rmd" } },
  {
    "iamcco/markdown-preview.nvim",
    as = "markdown-preview.nvim",
    run = ":call mkdp#util#install()",
    ft = { "markdown", "pandoc.markdown", "rmd" },
  },
  -- { "SidOfc/mkdx", ft = { "markdown" } },
  -- log
  { "mtdl9/vim-log-highlighting" },
  -- csv
  -- { "chen244/csv-tools.lua" },
  { "mechatroner/rainbow_csv", ft = { "csv" } },
  -- json
  { "b0o/schemastore.nvim" },

  -- AI {{
  { "github/copilot.vim", on = "User VimLoaded" },
  -- }}

  -- Debug {{
  { "sentriz/vim-print-debug" },
  -- }}

  -- REPL {{
  { "hkupty/iron.nvim", on = "User VimLoaded" },
  -- }}

  -- Test {{
  { "nvim-neotest/neotest", on = "User VimLoaded" },
  -- }}

  -- Task Runner{{
  { "yutkat/taskrun.nvim", on = "User VimLoaded" },
  -- { "michaelb/sniprun", run = "bash ./install.sh", on = "CmdlineEnter" },
  -- }}

  -- Neovim
  { "wadackel/nvim-syntax-info", on = "User VimLoaded" },
  { "bfredl/nvim-luadev", on = "User VimLoaded" },
  -- }}

  -- Something fun {{
  { "ryoppippi/bad-apple.vim", branch = "main" },
  -- }}
}

for i, v in ipairs(plugin_list) do
  plugin_list[i].as = v.as or vim.fn.fnamemodify(v[1], ":t:r")
end

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
local config_dir = vim.fn.stdpath("config") .. "/lua/plugin/config/"
local fd = vim.loop.fs_scandir(config_dir)
if fd then
  while true do
    local file_name, type = vim.loop.fs_scandir_next(fd)
    if not file_name then
      break
    end
    if type ~= "file" then
      goto continue
    end
    local plugin_name = file_name:gsub("%.lua$", "")
    -- local plugin_name = vim.fn.fnamemodify(file_name, ":t:r")
    if jp.tap(plugin_name) then
      vim.cmd("luafile " .. config_dir .. file_name)
    end
    ::continue::
  end
end

-- check if all plugins are istalled
vim.api.nvim_create_autocmd("User VimLoaded", {
  callback = function()
    for _, name in ipairs(jp.names()) do
      if not tb(jp.tap(name)) then
        jp.sync()
        pcall(vim.api.nvim_command, "LuaCacheClear")
        vim.cmd("source $MYVIMRC")
        break
      end
    end
  end,
})
