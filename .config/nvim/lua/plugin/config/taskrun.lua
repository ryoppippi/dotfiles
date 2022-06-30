require("taskrun").setup()
vim.keymap.set("n", "[make]m", "<Cmd>TaskRunToggle<CR>", { silent = true })
vim.keymap.set("n", "[make]q", "<Cmd>TaskRunToggle<CR>", { silent = true })
vim.keymap.set("n", "[make]r", "<Cmd>TaskRunLast()<CR>", { silent = true })
