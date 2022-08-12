local load = require("utils.plugin").load

vim.g.jetpack_copy_method = "symlink"
vim.g.jetpack_optimization = 1
vim.g.jetpack_njobs = 16
-- vim.g.enabled_snippet = "vsnip"
vim.g.enabled_snippet = "luasnip"

-- check if jetpack is installed
local status, _ = load("vim-jetpack")
if not tb(status) then
  local dir = vim.fn.expand(vim.fn.stdpath("data") .. "/site/pack/jetpack/opt/vim-jetpack")
  if not tb(vim.fn.isdirectory(dir)) then
    local url = "https://github.com/tani/vim-jetpack"
    vim.cmd(string.format("!git clone %s %s", url, dir))
  end
  load("vim-jetpack")
end

local jp = require("jetpack")

local plugin_list = {
  -- Plugin management {{
  { "tani/vim-jetpack", opt = true, frozen = true },
  { "lewis6991/impatient.nvim", opt = true },
  { "tweekmonster/startuptime.vim" },
  -- }}

  -- Essential libraries {{
  { "nvim-lua/plenary.nvim" },
  { "kkharji/sqlite.lua" },
  { "ray-x/guihua.lua" },
  { "MunifTanjim/nui.nvim" },
  { "nvim-lua/popup.nvim" },
  { "rcarriga/nvim-notify" },
  { "kyazdani42/nvim-web-devicons" },
  { "tpope/vim-repeat" },
  { "monaqa/peridot.vim" },
  { "antoinemadec/FixCursorHold.nvim" },
  { "vim-denops/denops.vim" },
  { "echasnovski/mini.nvim", branch = "stable" },
  -- }}

  -- StatusLine {{
  { "feline-nvim/feline.nvim" },
  { "SmiteshP/nvim-gps" },
  { "SmiteshP/nvim-navic" },
  -- }}

  -- Other UI Components {{
  { "mvllow/modes.nvim" },
  { "petertriho/nvim-scrollbar" },
  -- }}

  -- Moving Cursor {{
  { "unblevable/quick-scope" },
  { "yutkat/wb-only-current-line.nvim" },
  { "deton/jasegment.vim" }, -- Japanese word moving
  { "yuki-yano/fuzzy-motion.vim" },
  -- }}

  -- File Management {{

  -- filer {{
  { "nvim-neo-tree/neo-tree.nvim", branch = "v2.x" },
  -- }}

  -- window
  { "kwkarlwang/bufresize.nvim" },
  { "simeji/winresizer" },
  { "camspiers/lens.vim" },
  { "tkmpypy/chowcho.nvim" },

  -- buffer
  -- { "stevearc/stickybuf.nvim" },
  { "famiu/bufdelete.nvim" },

  -- buffer move
  { "Bakudankun/BackAndForward.vim" },

  -- file format settings
  { "spywhere/detect-language.nvim" },
  { "Shougo/context_filetype.vim" },
  { "lfilho/cosco.vim" },
  { "nmac427/guess-indent.nvim" },
  { "thinca/vim-prettyprint" },
  { "RRethy/nvim-align" },
  -- { "zsugabubus/crazy8.nvim" },

  -- root dir
  { "ahmedkhalf/project.nvim" },

  -- }}

  -- Editing {{

  -- textobj
  { "kana/vim-textobj-user" },
  { "osyo-manga/vim-textobj-blockwise" },

  -- edit and insert
  { "thinca/vim-partedit" },

  -- brackets and parentheses
  { "machakann/vim-sandwich" },
  { "andymass/vim-matchup" },
  { "windwp/nvim-autopairs" },
  { "windwp/nvim-ts-autotag" },
  { "RRethy/nvim-treesitter-endwise" },
  -- { "abecodes/tabout.nvim" },
  -- { "cohama/lexima.vim" },

  -- comment
  -- commentout
  { "numToStr/Comment.nvim" },
  -- comment generation
  { "s1n7ax/nvim-comment-frame" },
  { "LudoPinelli/comment-box.nvim" },
  { "danymat/neogen" },

  -- yank and paste
  { "gbprod/substitute.nvim" },
  { "hrsh7th/nvim-pasta" },
  { "Rasukarusan/nvim-block-paste" },
  { "yuki-yano/deindent-yank.vim" },
  -- { "gbprod/yanky.nvim" },
  -- { "AckslD/nvim-anywise-reg.lua" },

  -- Select
  { "terryma/vim-expand-region" },
  { "terryma/vim-multiple-cursors" },
  { "kana/vim-niceblock" },

  -- Swap Arguments
  { "machakann/vim-swap" },

  -- Join
  { "AckslD/nvim-trevJ.lua" },

  -- Adding,subtracting,change cases
  { "monaqa/dial.nvim", opt = true },
  { "deris/vim-rengbang" },
  -- }}

  -- Builtin Enhancements {{
  -- Quickfix
  { "thinca/vim-qfreplace" },
  { "itchyny/vim-qfedit" },
  { "kevinhwang91/nvim-bqf", ft = "qf" },

  -- Undo
  { "simnalamburt/vim-mundo" },

  -- Diff
  { "AndrewRadev/linediff.vim" },

  -- Macro
  { "zdcthomas/medit" },

  -- Register
  { "tversteeg/registers.nvim", branch = "main" },

  -- Mark
  { "chentoast/marks.nvim" },

  -- Fold
  -- { "lambdalisue/readablefold.vim" },
  { "monaqa/pretty-fold.nvim", branch = "for_stable_neovim" },

  -- Docs
  { "thinca/vim-ref" },
  { "folke/which-key.nvim" },
  { "nanotee/luv-vimdocs" },

  -- SpellCorrect
  { "lewis6991/spellsitter.nvim" },

  -- Command
  { "wsdjeg/vim-fetch" },
  { "jghauser/mkdir.nvim" },
  { "sQVe/sort.nvim" },
  { "tyru/capture.vim" },
  { "smjonas/live-command.nvim" },

  -- Terminal
  { "akinsho/toggleterm.nvim" },
  { "lambdalisue/guise.vim" },
  { "lambdalisue/askpass.vim" },

  -- Session
  -- { "rmagatti/auto-session" },

  -- }}

  -- New Features {{

  -- Browser
  { "tyru/open-browser.vim" },
  { "tyru/open-browser-github.vim" },
  { "tyru/open-browser-unicode.vim" },

  -- Screenshot
  { "segeljakt/vim-silicon" },
  { "kristijanhusak/vim-carbon-now-sh" },

  -- Template
  { "mattn/vim-sonictemplate" },

  -- Color Management
  { "max397574/colortils.nvim" },

  -- Git support{{

  -- git command assistant
  { "rhysd/committia.vim" },
  { "hotwatermorning/auto-git-diff" },
  { "akinsho/git-conflict.nvim" },
  { "sindrets/diffview.nvim" },
  { "yutkat/convert-git-url.nvim" },

  -- show messages
  { "lewis6991/gitsigns.nvim" },
  { "rhysd/git-messenger.vim" },

  -- Github
  { "pwntester/octo.nvim" },
  -- { "skanehira/denops-gh.vim" },

  -- }}

  -- Docker {{
  { "skanehira/denops-docker.vim" },
  -- }}

  -- REST {{
  { "NTBBloodbath/rest.nvim" },
  -- }}

  -- GraphAPI {{
  { "skanehira/denops-graphql.vim" },
  -- }}

  -- Shell {{
  { "lambdalisue/vim-manpager" },
  -- }}

  -- }}

  -- Search {{
  { "haya14busa/vim-asterisk" },
  { "hrsh7th/vim-searchx" },
  { "monaqa/modesearch.vim" },
  { "kevinhwang91/nvim-hlslens", as = "hlslens" },
  -- }}

  -- Rename {{
  { "smjonas/inc-rename.nvim", as = "inc_rename" },
  -- }}

  -- Fuzzy Finder {{
  -- Telescope {{
  { "nvim-telescope/telescope.nvim" },
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
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "jose-elias-alvarez/null-ls.nvim" },
  { "lukas-reineke/lsp-format.nvim" },

  -- UI
  { "onsails/lspkind.nvim" },
  { "folke/lsp-colors.nvim" },
  { "j-hui/fidget.nvim" },
  { "rmagatti/goto-preview" },
  -- }}
  -- }}

  -- Nvim-cmp {{
  { "hrsh7th/nvim-cmp", as = "cmp", opt = true },
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
  { "hrsh7th/cmp-vsnip", opt = true, enabled = vim.g.enabled_snippet == "vsnip" },
  { "saadparwaiz1/cmp_luasnip", opt = true, enabled = vim.g.enabled_snippet == "luasnip" },
  { "ryoppippi/cmp-copilot", branch = "dev/add-copilot-loaded-detecter", opt = true },
  { "petertriho/cmp-git", as = "cmp_git", opt = true },
  -- { "hrsh7th/cmp-copilot", opt = true },
  -- { "uga-rosa/cmp-dictionary", opt = true },
  -- { "tzachar/cmp-tabnine", run = "./install.sh" },
  -- { "octaltree/cmp-look", opt = true },
  -- }}

  -- Nvim-treesitter {{
  { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
  { "yioneko/nvim-yati" },
  { "JoosepAlviste/nvim-ts-context-commentstring" },

  -- textobj
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "RRethy/nvim-treesitter-textsubjects" },
  { "David-Kunz/treesitter-unit" },

  -- UI
  { "haringsrob/nvim_context_vt" },
  { "romgrk/nvim-treesitter-context" },
  -- }}

  -- ColorScheme {{
  { "navarasu/onedark.nvim" },
  { "ray-x/starry.nvim" },
  { "rebelot/kanagawa.nvim" },
  -- }}

  -- Heiglighting {{
  { "norcalli/nvim-colorizer.lua" },
  { "folke/todo-comments.nvim" },
  { "m-demare/hlargs.nvim" },
  { "p00f/nvim-ts-rainbow" },
  { "RRethy/vim-illuminate", as = "illuminate" },
  -- }}

  -- Snippets {{
  { "hrsh7th/vim-vsnip", enabled = (vim.g.enabled_snippet == "vsnip") },
  { "L3MON4D3/LuaSnip", as = "luasnip", enabled = (vim.g.enabled_snippet == "luasnip"), opt = true },

  -- utils
  { "kevinhwang91/nvim-hclipboard", as = "hclipboard" }, -- prevent polluting clipboard
  -- { "smjonas/snippet-converter.nvim" },

  -- snippets collection {{
  { "craigmac/vim-vsnip-snippets" },
  { "honza/vim-snippets" },
  { "rafamadriz/friendly-snippets" },
  -- }}

  -- language specific snippets {{
  -- python
  { "cstrap/flask-snippets" },
  { "cstrap/python-snippets" },
  -- zig
  { "Metalymph/zig-snippets" },
  -- web
  { "fivethree-team/vscode-svelte-snippets" },
  { "xabikos/vscode-javascript" },
  -- }}

  -- }}

  -- Language specific plugins {{
  -- javascript
  { "vuki656/package-info.nvim" },
  { "bennypowers/nvim-regexplainer", as = "regexplainer" },
  -- typescript
  { "jose-elias-alvarez/typescript.nvim" },
  { "dhruvasagar/vim-table-mode" },
  -- sql
  { "jsborjesson/vim-uppercase-sql" },
  -- lua
  { "milisims/nvim-luaref" },
  { "folke/lua-dev.nvim" },
  -- rust
  { "simrat39/rust-tools.nvim" },
  -- go
  { "ray-x/go.nvim" },
  -- markdown
  -- { "previm/previm", ft = { "markdown", "pandoc.markdown", "rmd" } },
  {
    "iamcco/markdown-preview.nvim",
    as = "markdown-preview.nvim",
    run = ":call mkdp#util#install()",
    ft = { "markdown", "pandoc.markdown", "rmd" },
  },
  { "AckslD/nvim-FeMaco.lua" },
  -- { "SidOfc/mkdx", ft = { "markdown" } },
  -- log
  { "mtdl9/vim-log-highlighting" },
  -- csv
  -- { "chen244/csv-tools.lua" },
  { "mechatroner/rainbow_csv", ft = { "csv" } },
  -- json
  { "b0o/schemastore.nvim" },
  -- swift
  -- { "xbase-lab/xbase", run = "make install" },
  -- }}

  -- AI {{
  { "github/copilot.vim", on = { "InsertEnter" } },
  -- }}

  -- Debug {{
  { "sentriz/vim-print-debug" },
  -- }}

  -- REPL {{
  { "hkupty/iron.nvim" },
  -- }}

  -- Test {{
  { "nvim-neotest/neotest" },
  -- }}

  -- Task Runner{{
  { "thinca/vim-quickrun" },
  { "lambdalisue/vim-quickrun-neovim-job" },
  { "stevearc/overseer.nvim" },
  -- }}

  -- Neovim
  { "wadackel/nvim-syntax-info" },
  { "bfredl/nvim-luadev" },
  -- }}

  -- Something fun {{
  { "ryoppippi/bad-apple.vim", branch = "main" },
  -- }}
}

for i, v in ipairs(plugin_list) do
  plugin_list[i].as = v.as or vim.fn.fnamemodify(v[1], ":t:r")
end

local startup_list = {
  "auto-session",
  "copilot",
  "vim-print-debug",
  "vim-sonictemplate",
  "vim-searchx",
}

local vim_enter_list = {
  "telescope",
  "todo-comments",
  "nvim-treesitter",
  "feline",
  "xbase",
  "mason",
  "mason-lspconfig",
}

local my_plugin_list = {
  "tabline",
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
local config_dir = vim.fn.stdpath("config") .. "/lua/plugin/config/"
local fd = vim.loop.fs_scandir(config_dir)
if fd then
  while true do
    local file_name, type = vim.loop.fs_scandir_next(fd)
    if not file_name then
      break
    end
    if type == "file" then
      local plugin_name = file_name:gsub("%.lua$", "")
      local file_path = config_dir .. file_name
      if jp.tap(plugin_name) then
        if vim.tbl_contains(startup_list, plugin_name) then
          vim.cmd.luafile(file_path)
        elseif vim.tbl_contains(vim_enter_list, plugin_name) then
          vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
              vim.cmd.luafile(file_path)
            end,
          })
        else
          vim.defer_fn(function()
            vim.cmd.luafile(file_path)
          end, 0)
        end
      end
      if vim.tbl_contains(my_plugin_list, plugin_name) then
        vim.defer_fn(function()
          vim.cmd.luafile(file_path)
        end, 0)
      end
    end
  end
end

-- check if all plugins are istalled
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    for _, name in ipairs(jp.names()) do
      if not tb(jp.tap(name)) then
        jp.sync()
        pcall(vim.cmd.LuaCacheClear, "")
        vim.cmd.source(os.getenv("MYVIMRC"))
        break
      end
    end
  end,
})
