-- vim.g.enabled_snippet = "vsnip"
vim.g.enabled_snippet = "luasnip"

local load_denops = require("utils.plugin").load_denops_on_lazy

local plugin_list = {
  -- Plugin management {{
  { "dstein64/vim-startuptime", cmd = "StartupTime" },
  -- }}

  -- Essential libraries {{
  { "nvim-lua/popup.nvim" },
  { "MunifTanjim/nui.nvim" },
  { "tpope/vim-repeat", lazy = false },
  { "monaqa/peridot.vim" },
  { "vim-denops/denops.vim", event = { "CursorHold", "FocusLost" } },
  -- }}

  -- Other UI Components {{
  { "mvllow/modes.nvim", event = "ModeChanged" },
  {
    "petertriho/nvim-scrollbar",
    event = { "BufReadPre" },
    dependencies = { "kevinhwang91/nvim-hlslens" },
  },
  { "levouh/tint.nvim", event = "VeryLazy", config = true },
  -- }}

  -- Moving Cursor {{
  { "unblevable/quick-scope", event = "VeryLazy" },
  { "yutkat/wb-only-current-line.nvim", event = "VeryLazy" },
  { "deton/jasegment.vim", event = "VeryLazy" }, -- Japanese word moving
  {
    "yuki-yano/fuzzy-motion.vim",
    keys = {
      { "<CR>", "<CMD>FuzzyMotion<CR>", { "n", "v", "x" } },
    },
    dependencies = { "vim-denops/denops.vim" },
    config = load_denops("fuzzy-motion.vim"),
  },
  -- }}

  -- File Management {{

  -- window
  { "kwkarlwang/bufresize.nvim", event = "BufEnter", config = true },
  {
    "camspiers/lens.vim",
    event = "VeryLazy",
    init = function()
      vim.g["lens#disabled_filetypes"] = { "neo-tree", "quickfix" }
    end,
  },

  { "stevearc/stickybuf.nvim", event = "VimEnter", config = true },
  { "famiu/bufdelete.nvim", event = "VeryLazy" },

  -- buffer move
  -- { "Bakudankun/BackAndForward.vim" },

  -- file format settings
  { "spywhere/detect-language.nvim", event = "BufReadPre" },
  { "Shougo/context_filetype.vim", event = "VeryLazy" },
  { "nmac427/guess-indent.nvim", event = "BufReadPre" },
  { "thinca/vim-prettyprint", event = "VeryLazy" },
  { "RRethy/nvim-align", cmd = { "Align" } },
  -- { "zsugabubus/crazy8.nvim" },

  -- root dir
  {
    "ahmedkhalf/project.nvim",
    event = "BufWinEnter",
    config = function()
      require("project_nvim").setup({})
    end,
  },
  { "yyk/find-git-root.nvim" },

  {
    "princejoogie/chafa.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "m00qek/baleia.nvim",
    },
    event = "VeryLazy",
    config = {},
  },

  -- }}

  -- Editing {{

  -- textobj
  { "kana/vim-textobj-user" },
  { "osyo-manga/vim-textobj-blockwise" },

  -- edit and insert
  { "thinca/vim-partedit", event = "VeryLazy" },

  -- brackets and parentheses
  { "machakann/vim-sandwich", event = "VeryLazy" },
  { "windwp/nvim-ts-autotag", dependencies = { "nvim-treesitter/nvim-treesitter" } },
  { "RRethy/nvim-treesitter-endwise", dependencies = { "nvim-treesitter/nvim-treesitter" }, event = "BufReadPost" },
  -- { "kylechui/nvim-surround" },
  -- { "abecodes/tabout.nvim" },
  -- { "cohama/lexima.vim" },

  -- comment
  -- commentout
  -- comment generation
  { "s1n7ax/nvim-comment-frame", config = true },
  { "LudoPinelli/comment-box.nvim", event = "CmdlineEnter" },
  { "danymat/neogen", config = true },

  -- yank and paste
  { "Rasukarusan/nvim-block-paste", event = "VeryLazy" },
  { "yuki-yano/deindent-yank.vim", event = "VeryLazy" },
  -- { "AckslD/nvim-anywise-reg.lua" },

  -- Select
  { "mg979/vim-visual-multi", event = "VeryLazy" },
  { "kana/vim-niceblock" },

  -- Swap Arguments
  { "machakann/vim-swap", keys = { "g>", "g<", "gs" } },

  -- Adding,subtracting,change cases
  { "deris/vim-rengbang", event = "VeryLazy" },
  -- }}

  -- Builtin Enhancements {{
  -- Quickfix
  { "thinca/vim-qfreplace", ft = "qf", cmd = { "Qfreplace" } },
  { "itchyny/vim-qfedit", ft = "qf" },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").enable()
    end,
  },
  { "delphinus/qfheight.nvim", ft = "qf", config = true },

  -- Undo
  { "simnalamburt/vim-mundo" },

  -- Diff
  { "AndrewRadev/linediff.vim", event = "VeryLazy" },

  -- Register
  { "tversteeg/registers.nvim", brnch = "main" },

  -- Mark
  { "chentoast/marks.nvim", event = "VeryLazy" },

  -- Fold
  -- { "lambdalisue/readablefold.vim" },
  -- { "anuvyklack/pretty-fold.nvim", event = "BufReadPost", config = true },
  -- { "anuvyklack/fold-preview.nvim", event = "BufReadPost", config = true },

  -- Docs
  { "thinca/vim-ref" },
  { "nanotee/luv-vimdocs" },

  -- SpellCorrect
  { "lewis6991/spellsitter.nvim", config = true },

  -- Command
  { "wsdjeg/vim-fetch", lazy = false },
  { "jghauser/mkdir.nvim", lazy = false },
  { "sQVe/sort.nvim", cmd = { "Sort" }, config = true },
  { "tyru/capture.vim", cmd = { "Capture" } },

  -- Terminal
  {
    "lambdalisue/guise.vim",
    event = { "CmdlineEnter", "CursorHold", "FocusLost" },
    dependencies = { "vim-denops/denops.vim" },
    config = load_denops("guise.vim"),
  },
  {
    "lambdalisue/askpass.vim",
    enabled = false,
    event = { "CmdlineEnter", "CursorHold", "FocusLost" },
    dependencies = { "vim-denops/denops.vim" },
    config = load_denops("askpass.vim"),
  },

  -- }}

  -- New Features {{

  -- Screenshot
  {
    "segeljakt/vim-silicon",
    cmd = "Silicon",
    init = function()
      vim.g.silicon = {
        theme = "gruvbox",
      }
    end,
  },
  { "kristijanhusak/vim-carbon-now-sh" },

  -- Git support{{

  -- git command assistant
  { "rhysd/committia.vim", ft = { "git" } },
  { "hotwatermorning/auto-git-diff", event = "VeryLazy" },
  { "akinsho/git-conflict.nvim", ft = { "git" }, config = true },
  { "sindrets/diffview.nvim", ft = { "git" } },
  { "yutkat/convert-git-url.nvim" },

  -- show messages

  -- Github
  { "pwntester/octo.nvim", cmd = "Octo" },
  -- { "skanehira/denops-gh.vim" },

  -- }}

  -- Docker {{
  {
    "skanehira/denops-docker.vim",
    dependencies = { "vim-denops/denops.vim" },
    config = load_denops("denops-docker.vim"),
  },
  -- }}

  -- GraphAPI {{
  {
    "skanehira/denops-graphql.vim",
    dependencies = { "vim-denops/denops.vim" },
    config = load_denops("denops-graphql.vim"),
  },
  -- }}

  -- Shell {{
  { "lambdalisue/vim-manpager", cmd = { "ASMANPAGER", "Man" } },
  -- }}

  -- }}

  -- Search {{
  { "kevinhwang91/nvim-hlslens", config = true },
  -- }}

  -- Rename {{
  { "smjonas/inc-rename.nvim", cmd = "IncRename", config = true },

  -- }}

  -- }}

  -- Languages
  -- Nvim-LSP {{
  { "lukas-reineke/lsp-format.nvim", config = true },
  { "folke/lsp-colors.nvim", event = "ColorSchemePre", config = true },
  -- UI
  { "mrshmllow/document-color.nvim" },
  { "kosayoda/nvim-lightbulb" },
  -- { "hrsh7th/nvim-gtd" },
  -- }}

  -- Heiglighting {{
  {
    "RRethy/vim-illuminate",
    init = function()
      vim.g.Illuminate_delay = 500
    end,
  },
  -- }}

  -- utils
  { "kevinhwang91/nvim-hclipboard", name = "hclipboard", config = true }, -- prevent polluting clipboard

  -- }}

  -- Language specific plugins {{
  -- javascript
  { "vuki656/package-info.nvim", ft = { "json" } },
  {
    -- "barrett-ruth/import-cost.nvim",
    dir = "/Users/ryoppippi/ghq/github.com/ryoppippi/import-cost.nvim",
    build = "sh install.sh yarn",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "vue",
      "svelte",
    },
    config = function()
      require("import-cost").setup({
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
          "svelte",
        },
      })
    end,
  },
  -- typescript
  { "jose-elias-alvarez/typescript.nvim" },
  { "dhruvasagar/vim-table-mode", ft = { "markdown" } },
  -- sql
  { "jsborjesson/vim-uppercase-sql", ft = { "sql" } },
  -- lua
  { "milisims/nvim-luaref" },
  -- rust
  { "simrat39/rust-tools.nvim" },
  -- go
  { "ray-x/go.nvim" },
  -- markdown
  -- { "previm/previm", ft = { "markdown", "pandoc.markdown", "rmd" } },
  {
    "iamcco/markdown-preview.nvim",
    build = ":call mkdp#util#install()",
    ft = { "markdown", "pandoc.markdown", "rmd" },
  },
  { "AckslD/nvim-FeMaco.lua", config = true, cmd = "FeMaco" },
  -- { "SidOfc/mkdx", ft = { "markdown" } },
  -- log
  { "mtdl9/vim-log-highlighting", ft = { "log" } },
  -- csv
  { "mechatroner/rainbow_csv", ft = { "csv" } },
  -- json
  { "b0o/schemastore.nvim" },
  -- }}

  -- REPL {{
  -- { "hkupty/iron.nvim" },
  -- }}

  -- Test {{
  { "nvim-neotest/neotest" },
  -- }}

  -- Task Runner{{
  { "thinca/vim-quickrun" },
  { "lambdalisue/vim-quickrun-neovim-job" },
  { "stevearc/overseer.nvim", enabled = false },
  -- }}

  -- Debug {{
  { "PatschD/zippy.nvim", keys = { "<leader>L" } },
  -- }}

  -- Neovim
  { "bfredl/nvim-luadev" },
  -- }}

  -- Something fun {{
  {
    "ryoppippi/bad-apple.vim",
    branch = "main",
    cmd = "BadApple",
    dependencies = { "vim-denops/denops.vim" },
    config = load_denops("bad-apple.vim"),
  },
  -- }}
}

return plugin_list
