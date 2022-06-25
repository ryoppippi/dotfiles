local plugin_name = "telescope"

local function loading()
  local telescope = require(plugin_name)
  local actions = require(plugin_name .. ".actions")
  local previewers = require(plugin_name .. ".previewers")

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
        },
        i = {
          ["<C-q>"] = require("telescope.actions").send_to_qflist + require("telescope.actions").open_qflist,
          ["<C-s>"] = require("telescope.actions").send_selected_to_qflist + require("telescope.actions").open_qflist,
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
  local le = function(name)
    pcall(telescope.load_extension, name)
  end
  le("fzf")
  le("file_browser")
  le("notify")
  le("media_files")
  le("ui-select")
  le("frecency")
  le("heading")
  le("changes")
  le("env")
  le("termfinder")
  le("luasnip")
  le("ghq")
  le("gh")
  le("projects")
end

local function keymap()
  local key_opts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap("n", ",", "[TeLeader]", {})
  vim.keymap.set("n", "[TeLeader]", "<Nop>", { noremap = true, silent = true })
  vim.api.nvim_set_keymap("n", "[TeLeader]<cr>", "<cmd>WhichKey [TeLeader]<cr>", { noremap = true })

  local find_files_cmd = [[<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--smart-case,--files<cr>]]
  local current_buffer_fuzzy_find = [[<cmd>Telescope current_buffer_fuzzy_find fuzzy=false case_mode=ignore_case<cr>]]

  vim.keymap.set("n", "[TeLeader]f", find_files_cmd, key_opts)
  vim.keymap.set("n", "[TeLeader]<space>", [[<cmd>Telescope live_grep<cr>]], key_opts)
  vim.keymap.set("n", "[TeLeader].", [[<cmd>Telescope<cr>]], key_opts)
  vim.keymap.set("n", "[TeLeader],", [[<cmd>Telescope oldfiles<cr>]], key_opts)
  vim.keymap.set("n", "[TeLeader]e", [[<cmd>Telescope file_browser<cr>]], key_opts)
  vim.keymap.set("n", "[TeLeader]s", [[<cmd>Telescope grep_string<cr>]], key_opts)
  vim.keymap.set("n", "[TeLeader]t", [[<cmd>TodoTelescope<cr>]], key_opts)
  vim.keymap.set("n", "[TeLeader]r", [[<cmd>Telescope resume<cr>]], key_opts)
  vim.keymap.set("n", "[TeLeader]b", [[<cmd>Telescope buffers<cr>]], key_opts)
  vim.keymap.set("n", "[TeLeader]h", [[<cmd>Telescope help_tags<cr>]], key_opts)
  vim.keymap.set("n", "[TeLeader]H", [[<cmd>Telescope heading<cr>]], key_opts)
  vim.keymap.set("n", "[TeLeader]j", [[<cmd>Telescope jumplist<cr>]], key_opts)
  vim.keymap.set("n", "[TeLeader]o", [[<cmd>Telescope oldfiles<cr>]], key_opts)
  vim.keymap.set("n", "[TeLeader]g", [[<cmd>Telescope git_files<cr>]], key_opts)
  vim.keymap.set("n", "[TeLeader]q", [[<cmd>Telescope quickfix<cr>]], key_opts)
  vim.keymap.set("n", "[TeLeader]p", [[<cmd>Telescope pickers<cr>]], key_opts)
  vim.keymap.set("n", "[TeLeader]m", [[<cmd>Telescope marks<cr>]], key_opts)
  vim.keymap.set("n", "[TeLeader]c", [[<cmd>Telescope colorscheme<cr>]], key_opts)
  vim.keymap.set("n", "[TeLeader]d", current_buffer_fuzzy_find, key_opts)
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
require("utils.plugin").force_load_on_event(plugin_name, keymap)
