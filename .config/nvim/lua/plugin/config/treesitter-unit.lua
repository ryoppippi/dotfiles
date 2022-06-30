vim.keymap.set({ "x", "o" }, "iu", ':lua require"treesitter-unit".select()<CR>')
vim.keymap.set({ "x", "o" }, "au", ':lua require"treesitter-unit".select(true)<CR>')
