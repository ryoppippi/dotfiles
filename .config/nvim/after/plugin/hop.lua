local status, hop = pcall(require, "hop")
if (not status) then return end

hop.setup()

local opt = {silent = true, noremap = true}
vim.api.nvim_set_keymap('v', '<Leader>j', ':<C-u>HopWord<CR>', opt)
vim.api.nvim_set_keymap('n', '<Leader>j', ':<C-u>HopWord<CR>', opt)
vim.api.nvim_set_keymap('v', '<Leader>k', ':<C-u>HopChar1<CR>', opt)
vim.api.nvim_set_keymap('n', '<Leader>k', ':<C-u>HopChar1<CR>', opt)
vim.api.nvim_set_keymap('v', '<Leader>l', ':<C-u>HopLine<CR>', opt)
vim.api.nvim_set_keymap('n', '<Leader>l', ':<C-u>HopLine<CR>', opt)


