local status, telescope = pcall(require, 'telescope')
if (not status) then return end
local actions = require('telescope.actions')

local key_opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<Leader>o', [[<cmd>lua require('telescope.builtin').find_files()<cr>]], key_opts)
vim.api.nvim_set_keymap('n', '<Leader>f', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], key_opts)
vim.api.nvim_set_keymap('n', '\\', [[<cmd>lua require('telescope.builtin').buffers()<cr>]], key_opts)
vim.api.nvim_set_keymap('n', '<Leader>h', [[<cmd>lua require('telescope.builtin').help_tags()<cr>]], key_opts)


telescope.setup{
  defaults = {
    mappings = {
      n = {
        ["<esc>"] = actions.close
      },
    }
  },
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
  },
}
require('telescope').load_extension('fzf')
