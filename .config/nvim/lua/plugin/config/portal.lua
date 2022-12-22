require("portal").setup({})
vim.keymap.set("n", "g<c-i>", require("portal").jump_backward, {})
vim.keymap.set("n", "g<c-o>", require("portal").jump_forward, {})
