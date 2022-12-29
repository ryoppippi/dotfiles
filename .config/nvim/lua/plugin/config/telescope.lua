local le = function(name)
  return function()
    require("telescope").load_extension(name)
  end
end

return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-telescope/telescope-ui-select.nvim", config = le("ui-select") },
    { "nvim-telescope/telescope-frecency.nvim", dependencies = { "kkharji/sqlite.lua" }, config = le("frecency") },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make", config = le("fzf") },
    { "nvim-telescope/telescope-media-files.nvim", config = le("media_files") },
    { "nvim-telescope/telescope-symbols.nvim" },
    { "nvim-telescope/telescope-ghq.nvim", config = le("ghq") },
    { "nvim-telescope/telescope-github.nvim", config = le("gh") },
    { "LinArcX/telescope-env.nvim", config = le("env") },
    { "crispgm/telescope-heading.nvim", config = le("heading") },
    { "LinArcX/telescope-changes.nvim", config = le("changes") },
    { "tknightz/telescope-termfinder.nvim" },
    { "benfowler/telescope-luasnip.nvim", dependencies = { "L3MON4D3/LuaSnip" } },
    -- { "nvim-telescope/telescope-file-browser.nvim", config = le("file_browser") },
  },

  init = function()
    vim.api.nvim_set_keymap("n", ",", "[TeLeader]", {})
  end,

  cmd = { "Telescope" },

  keys = {
    -- stylua: ignore start
    { "[TeLeader]", [[<Nop>]] },
    { "[TeLeader]<cr>", [[<cmd>WhichKey [TeLeader]<cr>]] },
    { "[TeLeader]<space>", [[<cmd>Telescope live_grep<cr>]] },
    { "[TeLeader]f", [[<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--smart-case,--files<cr>]] },
    { "[TeLeader]d", [[<cmd>Telescope current_buffer_fuzzy_find fuzzy=false case_mode=ignore_case<cr>]] },
    { "[TeLeader].", [[<cmd>Telescope<cr>]] },
    { "[TeLeader],", [[<cmd>Telescope oldfiles<cr>]] },
    { "[TeLeader]e", [[<cmd>Telescope file_browser<cr>]] },
    { "[TeLeader]s", [[<cmd>Telescope grep_string<cr>]] },
    { "[TeLeader]t", [[<cmd>TodoTelescope<cr>]] },
    { "[TeLeader]r", [[<cmd>Telescope resume<cr>]] },
    { "[TeLeader]b", [[<cmd>Telescope buffers<cr>]] },
    { "[TeLeader]h", [[<cmd>Telescope help_tags<cr>]] },
    { "[TeLeader]H", [[<cmd>Telescope heading<cr>]] },
    { "[TeLeader]j", [[<cmd>Telescope jumplist<cr>]] },
    { "[TeLeader]o", [[<cmd>Telescope oldfiles<cr>]] },
    { "[TeLeader]g", [[<cmd>Telescope git_files<cr>]] },
    { "[TeLeader]q", [[<cmd>Telescope quickfix<cr>]] },
    { "[TeLeader]p", [[<cmd>Telescope pickers<cr>]] },
    { "[TeLeader]m", [[<cmd>Telescope marks<cr>]] },
    { "[TeLeader]c", [[<cmd>Telescope colorscheme<cr>]] },
    -- stylua: ignore end
  },

  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local previewers = require("telescope.previewers")

    local new_maker = function(filepath, bufnr, opts)
      opts = opts or {}
      filepath = vim.fn.expand(filepath)
      vim.loop.fs_stat(filepath, function(_, stat)
        if not stat then
          return
        end
        if stat.size > 100000 then
          return
        else
          previewers.buffer_previewer_maker(filepath, bufnr, opts)
        end
      end)
    end

    telescope.setup({
      defaults = require("telescope.themes").get_dropdown({
        mappings = {
          n = {
            ["<ESC>"] = actions.close,
            ["q"] = actions.close,
            ["<C-q>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
            ["<C-s>"] = require("telescope.actions").send_selected_to_qflist + require("telescope.actions").open_qflist,
            ["<C-l>"] = require("telescope.actions").send_to_loclist + require("telescope.actions").open_loclist,
          },
          i = {
            ["<C-q>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
            ["<C-s>"] = require("telescope.actions").send_selected_to_qflist + require("telescope.actions").open_qflist,
            ["<C-l>"] = require("telescope.actions").send_to_loclist + require("telescope.actions").open_loclist,
          },
        },
        initial_mode = "insert",
        prompt_prefix = "🔍",
        -- cache_picker = {
        -- 	num_pickers = -1,
        -- },
        vimgrep_arguments = {
          "rg",
          -- "ug",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },
        file_ignore_patterns = {
          ".git/",
        },
        color_devicons = true,
        use_less = true,
        scroll_strategy = "cycle",
        set_env = { ["COLORTERM"] = "truecolor" },
        buffer_previewer_maker = new_maker,
      }),
      pickers = {
        diagnostics = {
          initial_mode = "normal",
        },
        grep_string = {
          initial_mode = "normal",
        },
        oldfiles = {
          -- initial_mode = "normal",
        },
      },
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          -- case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        },
        file_browser = {
          initial_mode = "insert",
        },
        heading = {
          theme = "dropdown",
          initial_mode = "normal",
          treesitter = true,
        },
        frecency = {
          initial_mode = "normal",
          show_scores = true,
        },
        ["ui-select"] = {
          require("telescope.themes").get_cursor({
            initial_mode = "normal",
          }),
        },
      },
    })
    -- le("termfinder")
    -- le("luasnip")
    -- le("projects")
    -- le("noice")
  end,
}
