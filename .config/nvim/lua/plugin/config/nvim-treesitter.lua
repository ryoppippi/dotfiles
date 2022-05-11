if not require("utils.plugin").is_exists("nvim-treesitter") then
  return
end

local function loading()
  local ts = require("nvim-treesitter.configs")
  ts.setup({
    -- One of "all", "maintained" (parsers with maintainers), or a list of languages
    -- ensure_installed = "maintained",
    ignore_install = { "phpdoc" },

    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,

    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
      disable = {
        "toml",
      },
    },
    context_commentstring = {
      enable = true,
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
    textobjects = {
      select = {
        enable = true,

        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,

        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@conditional.outer",
          ["ic"] = "@conditional.inner",
          ["ab"] = "@block.outer",
          ["ib"] = "@block.inner",
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
    refactor = {
      -- highlight_definitions = {
      --   enable = true,
      --   -- Set to false if you have an `updatetime` of ~100.
      --   clear_on_cursor_move = true,
      -- },
      -- highlight_current_scope = { enable = true },
      -- smart_rename = {
      --   enable = true,
      --   keymaps = {
      --     smart_rename = "cW",
      --   },
      -- },
    },
    tree_docs = { enable = true },
  })

  local status_context, ts_context = pcall(require, "treesitter-context")
  if status_context then
    ts_context.setup({
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      throttle = true, -- Throttles plugin updates (may improve performance)
      max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
      patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
          "class",
          "function",
          "method",
          -- 'for',
          -- 'while',
          -- 'if',
          -- 'switch',
          -- 'case',
        },
        -- Example for a specific filetype.
        -- If a pattern is missing, *open a PR* so everyone can benefit.
        --   rust = {
        --       'impl_item',
        --   },
      },
      exact_patterns = {
        -- Example for a specific filetype with Lua patterns
        -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
        -- exactly match "impl_item" only)
        -- rust = true,
      },
    })
  end
end

vim.api.nvim_create_autocmd({ "BufEnter", "VimEnter" }, {
  callback = loading,
})
