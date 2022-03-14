local status, hop = pcall(require, "hop")
if (not status) then return end

hop.setup()

local opt = {silent = true, noremap = true}
vim.api.nvim_set_keymap('n', '<Leader>j', "<cmd>lua require'hop'.hint_words()<CR>", opt)
vim.api.nvim_set_keymap('v', '<Leader>j', "<cmd>lua require'hop'.hint_words()<CR>", opt)
vim.api.nvim_set_keymap('v', '<Leader>k', "<cmd>lua require'hop'.hint_char1()<CR>", opt)
vim.api.nvim_set_keymap('n', '<Leader>k', "<cmd>lua require'hop'.hint_char1()<CR>", opt)
vim.api.nvim_set_keymap('v', '<Leader>l', "<cmd>lua require'hop'.hint_lines()<CR>", opt)
vim.api.nvim_set_keymap('n', '<Leader>l', "<cmd>lua require'hop'.hint_lines()<CR>", opt)

