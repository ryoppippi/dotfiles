return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSInstall all",
  event = "BufReadPost",
  dependencies = {
    { "yioneko/nvim-yati" },
    { "JoosepAlviste/nvim-ts-context-commentstring" },

    -- textobj
    { "nvim-treesitter/nvim-treesitter-textobjects" },
    { "RRethy/nvim-treesitter-textsubjects" },
    { "David-Kunz/treesitter-unit" },

    -- UI
    { "haringsrob/nvim_context_vt" },
    { "romgrk/nvim-treesitter-context" },

    { "mrjones2014/nvim-ts-rainbow" },
  },

  config = function()
    require("nvim-treesitter.configs").setup({
      ignore_install = { "phpdoc" },

      auto_install = true,
      sync_install = false,

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
        disable = function(language, bufnr)
          return bufnr and vim.api.nvim_buf_line_count(bufnr) > 50000
        end,
      },
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
      },
      rainbow = {
        enable = true,
        extended_mode = true,
      },
      matchup = {
        enable = true,
      },
      yati = {
        enable = true,
      },
      autotag = {
        enable = true,
      },
      endwise = {
        enable = true,
      },
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ai"] = "@conditional.outer",
            ["ii"] = "@conditional.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aC"] = "@comment.outer",
            ["iC"] = "@comment.inner",
            ["ab"] = "@block.outer",
            ["ib"] = "@block.inner",
            ["al"] = "@loop.outer",
            ["il"] = "@loop.inner",
            ["ip"] = "@parameter.inner",
            ["ap"] = "@parameter.outer",
            -- ["iS"] = "@scopename.inner",
            -- ["aS"] = "@statement.outer",
            -- ["i"] = "@call.inner",
            -- ["a"] = "@comment.outer",
            -- ["iF"] = "@frame.inner",
            -- ["oF"] = "@frame.outer",
          },
        },
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@conditional.outer",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@conditional.outer",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@conditional.outer",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@conditional.outer",
          },
        },
      },
      textsubjects = {
        enable = true,
        prev_selection = ",", -- (Optional) keymap to select the previous selection
        keymaps = {
          ["."] = "textsubjects-smart",
          [";"] = "textsubjects-container-outer",
          ["i;"] = "textsubjects-container-inner",
        },
      },
      tree_docs = { enable = true },
    })
    -- vim.opt.foldmethod = "expr"
    -- vim.opt.foldlevel = 20
    -- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  end,
}
