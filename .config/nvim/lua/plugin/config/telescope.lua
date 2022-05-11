local plugin_name = "telescope"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  local telescope = require(plugin_name)
  local actions = require(plugin_name .. ".actions")

  telescope.setup({
    defaults = require("telescope.themes").get_dropdown({
      mappings = {
        n = {
          ["<ESC>"] = actions.close,
          ["q"] = actions.close,
        },
      },
      initial_mode = "insert",
      prompt_prefix = "🔍",
      -- cache_picker = {
      -- 	num_pickers = -1,
      -- },
      vimgrep_arguments = {
        "rg",
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
        "node_modules/*",
      },
      color_devicons = true,
      use_less = true,
      scroll_strategy = "cycle",
      set_env = { ["COLORTERM"] = "truecolor" },
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
        -- initial_mode = "normal",
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
  local le = telescope.load_extension
  pcall(le, "fzf")
  pcall(le, "file_browser")
  pcall(le, "notify")
  pcall(le, "media_files")
  pcall(le, "ui-select")
  pcall(le, "frecency")
  pcall(le, "heading")
  pcall(le, "changes")
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
  vim.keymap.set("n", "[TeLeader]z", [[<cmd>Telescope file_browser<cr>]], key_opts)
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
  vim.keymap.set("n", "[TeLeader]d", current_buffer_fuzzy_find, key_opts)
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
require("utils.plugin").force_load_on_event(plugin_name, keymap)
require("utils.plugin").force_load_on_event(plugin_name, keymap)
