-- vim.g.enabled_snippet = "vsnip"
vim.g.enabled_snippet = "luasnip"

local plugin_list = {
  -- Plugin management {{
  { "dstein64/vim-startuptime", cmd = "StartupTime" },
  -- }}

  -- Essential libraries {{
  { "nvim-lua/popup.nvim" },
  { "MunifTanjim/nui.nvim" },
  { "tpope/vim-repeat", lazy = false },
  { "monaqa/peridot.vim" },
  { "vim-denops/denops.vim", dependencies = { "yuki-yano/denops-lazy.nvim" }, event = { "VeryLazy" } },
  { "yuki-yano/denops-lazy.nvim", opts = { wait_load = false } },
  {
    "lambdalisue/kensaku.vim",
    dependencies = { "vim-denops/denops.vim" },
    config = function()
      require("denops-lazy").load("kensaku.vim")
    end,
  },
  -- }}

  -- Other UI Components {{
  { "mvllow/modes.nvim", event = "ModeChanged" },
  {
    "petertriho/nvim-scrollbar",
    event = { "BufReadPre" },
    dependencies = { "kevinhwang91/nvim-hlslens" },
  },
  -- { "levouh/tint.nvim", event = "VeryLazy", config = true },
  -- }}

  -- Moving Cursor {{
  { "unblevable/quick-scope", event = "VeryLazy" },
  { "yutkat/wb-only-current-line.nvim", event = "VeryLazy" },
  { "deton/jasegment.vim", event = "VeryLazy" }, -- Japanese word moving
  {
    "yuki-yano/fuzzy-motion.vim",
    keys = {
      { "<CR>", "<CMD>FuzzyMotion<CR>", mode = { "n", "v", "x" } },
    },
    dependencies = {
      { "vim-denops/denops.vim" },
      { "lambdalisue/kensaku.vim" },
    },
    init = function()
      vim.g.fuzzy_motion_matchers = { "fzf", "kensaku" }
    end,
    config = function()
      require("denops-lazy").load("fuzzy-motion.vim")
    end,
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

  -- Indent
  { "hrsh7th/nvim-dansa", event = "VeryLazy", config = true },
  -- { "nmac427/guess-indent.nvim", event = "BufReadPre", config = true },

  { "thinca/vim-prettyprint", event = "VeryLazy" },
  { "RRethy/nvim-align", cmd = { "Align" } },
  -- { "zsugabubus/crazy8.nvim" },

  -- root dir
  {
    "ahmedkhalf/project.nvim",
    event = "BufWinEnter",
    config = function(_, opts)
      require("project_nvim").setup(opts)
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
    opts = {},
  },

  -- }}

  -- Editing {{

  -- textobj
  { "kana/vim-textobj-user" },
  { "osyo-manga/vim-textobj-blockwise" },

  -- edit and insert
  { "thinca/vim-partedit", event = "VeryLazy" },

  -- rackets and parentheses
  -- { "machakann/vim-sandwich", event = "VeryLazy" },
  {
    "echasnovski/mini.surround",
    version = "*",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "sa", -- Add surrounding in Normal and Visual modes
        delete = "sd", -- Delete surrounding
        find = "sf", -- Find surrounding (to the right)
        find_left = "sF", -- Find surrounding (to the left)
        highlight = "", -- Highlight surrounding
        replace = "sr", -- Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`

        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    },
    config = function(_, opts)
      -- use gz mappings instead of s to prevent conflict with leap
      require("mini.surround").setup(opts)
    end,
  },
  { "windwp/nvim-ts-autotag", dependencies = { "nvim-treesitter/nvim-treesitter" } },
  -- { "RRethy/nvim-treesitter-endwise", dependencies = { "nvim-treesitter/nvim-treesitter" }, event = "BufReadPost" },
  -- { "abecodes/tabout.nvim" },
  -- { "cohama/lexima.vim" },

  -- comment
  -- commentout
  -- comment generation
  { "s1n7ax/nvim-comment-frame", config = true },
  { "LudoPinelli/comment-box.nvim", event = "VeryLazy" },
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
  { "tversteeg/registers.nvim", branch = "main", event = { "VeryLazy" }, config = true },

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
    dependencies = { "vim-denops/denops.vim" },
    event = { "User DenopsReady" },
    config = function()
      require("denops-lazy").load("guise.vim")
      vim.cmd([[
        let s:address = $GUISE_NVIM_ADDRESS
        if !empty(s:address)
            noautocmd call guise#open(s:address, argv())
        endif
      ]])
    end,
  },
  {
    "lambdalisue/askpass.vim",
    event = { "User DenopsReady" },
    config = function()
      require("denops-lazy").load("askpass.vim")
    end,
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
  -- {
  --   "skanehira/denops-docker.vim",
  --   dependencies = { "vim-denops/denops.vim" },
  --   config = function()
  --     require("denops-lazy").load("denops-docker.vim")
  --   end,
  -- },
  -- }}

  -- GraphAPI {{
  -- {
  --   "skanehira/denops-graphql.vim",
  --   dependencies = { "vim-denops/denops.vim" },
  --   config = function()
  --     require("denops-lazy").load("denops-graphql.vim")
  --   end,
  -- },
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
  { "folke/lsp-colors.nvim", event = "LspAttach", config = true },
  -- UI
  { "mrshmllow/document-color.nvim", event = "LspAttach" },
  { "kosayoda/nvim-lightbulb", event = "LspAttach" },
  { "zbirenbaum/neodim", event = "LspAttach", config = true },
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
    "barrett-ruth/import-cost.nvim",
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
    config = function()
      require("denops-lazy").load("bad-apple.vim")
    end,
  },
  -- }}
}

return plugin_list
