vim.keymap.set("i", "<Plug>(copilot-dummy-map)", [[copilot#Accept"]("<Tab>")]], { expr = true })
vim.keymap.set("i", "<C-h>", [[copilot#Accept("<CR>")]], { expr = true })
vim.keymap.set("i", "<C-l>", [[copilot#Dismiss()]], { script = true, nowait = true, expr = true })

vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""
vim.g.copilot_filetypes = { ["*"] = true }
-- vim.g.copilot_ignore_node_version = true
-- vim.g.copilot_node_command = "bun"
