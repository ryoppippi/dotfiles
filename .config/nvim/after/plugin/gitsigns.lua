local status, gitsigns = pcall(require, "gitsigns")
if (not status) then return end

gitsigns.setup({
  signs = {
    add          = { text = '+' },
    change       = { text = '~' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~_' },
  },
  current_line_blame = true,
  on_attach = function (buffer)
    vim.api.nvim_set_keymap('n', '<Leader>dh', ':Gitsigns preview_hunk<CR>', { silent = true, noremap = true })
    vim.api.nvim_set_keymap('n', '<Leader>dd', ':Gitsigns diffthis<CR>', { silent = true, noremap = true })
    vim.api.nvim_set_keymap('n', '<Leader>dc', ':Gitsigns toggle_deleted<CR>', { silent = true, noremap = true })
  end
})
