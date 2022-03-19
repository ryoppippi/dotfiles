local status, telescope = pcall(require, 'telescope')
if (not status) then return end
local actions = require('telescope.actions')

local key_opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<Leader>ff', [[<cmd>lua require('telescope.builtin').find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>]], key_opts)
vim.api.nvim_set_keymap('n', '<Leader>fk', ':Telescope file_browser<cr>', key_opts)
vim.api.nvim_set_keymap('n', '<Leader>fl', [[<cmd>lua require('telescope.builtin').live_grep()<cr>]], key_opts)
vim.api.nvim_set_keymap('n', '<Leader>fw', [[<cmd>lua require('telescope.builtin').grep_string()<cr>]], key_opts)
vim.api.nvim_set_keymap('n', '<Leader>ft', ":TodoTelescope<cr>", key_opts)
vim.api.nvim_set_keymap('n', '<Leader>f;', ":Telescope<space>", {noremap = true})
vim.api.nvim_set_keymap('n', '<Leader>fr', [[<cmd>lua require('telescope.builtin').resume()<cr>]], key_opts)
vim.api.nvim_set_keymap('n', '<Leader>fd', [[<cmd>lua require('telescope.builtin').diagnostics()<cr>]], key_opts)
vim.api.nvim_set_keymap('n', '<Leader>fb', [[<cmd>lua require('telescope.builtin').buffers()<cr>]], key_opts)
vim.api.nvim_set_keymap('n', '<Leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<cr>]], key_opts)
vim.api.nvim_set_keymap('n', '<Leader>fj', [[<cmd>lua require('telescope.builtin').jumplist()<cr>]], key_opts)
vim.api.nvim_set_keymap('n', '<Leader>fo', [[<cmd>lua require('telescope.builtin').oldfiles()<cr>]], key_opts)
vim.api.nvim_set_keymap('n', '<Leader>fq', [[<cmd>lua require('telescope.builtin').quickfix()<cr>]], key_opts)
vim.api.nvim_set_keymap('n', '<Leader>fp', [[<cmd>lua require('telescope.builtin').pickers()<cr>]], key_opts)

vim.api.nvim_set_keymap('n', 'gd', [[<cmd>lua require('telescope.builtin').lsp_definitions()<cr>]], key_opts)
vim.api.nvim_set_keymap('n', 'gt', [[<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>]], key_opts)
vim.api.nvim_set_keymap('n', 'gi', [[<cmd>lua require('telescope.builtin').lsp_implementations()<cr>]], key_opts)
vim.api.nvim_set_keymap('n', 'gr', [[<cmd>lua require('telescope.builtin').lsp_references()<cr>]], key_opts)
vim.api.nvim_set_keymap('n', '<leader>ca', [[<cmd>lua require('telescope.builtin').lsp_code_actions()<cr>]], key_opts)


telescope.setup{
  defaults = {
    mappings = {
      n = {
        ["<ESC>"] = actions.close,
        ["q"] = actions.close,
      },
    },
    cache_picker = {
      num_pickers = -1,
    },
  },
  pickers = {
    diagnostics = {
      theme = "dropdown"
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
    file_browser = {
      initial_mode = 'normal',
    },
  },
}
require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')

