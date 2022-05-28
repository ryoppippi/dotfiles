-- open config
vim.api.nvim_create_user_command("Config", "execute 'e' . fnamemodify($MYVIMRC, ':h')", { nargs = "*" })
vim.keymap.set("n", "<leader>.", "<cmd>Config<cr>", { noremap = true, silent = true })

-- custom terminal command
vim.api.nvim_create_user_command("T", "tabe | terminal <args>", { nargs = "*" })

-- indent change
vim.api.nvim_create_user_command("IndentChange", "set tabstop=<args> shiftwidth=<args>", { force = true, nargs = 1 })

vim.api.nvim_create_user_command("EncodingReload", "execute 'e ++enc=<args>'", { force = true, nargs = 1 })

-- count word
vim.api.nvim_create_user_command("CountWord", function()
  local input = vim.fn.input("", "':%s/\\<<C-r><C-w>\\>/&/gn'")
  vim.cmd(input)
  vim.fn.histadd("cmd", input)
end, { force = true })
