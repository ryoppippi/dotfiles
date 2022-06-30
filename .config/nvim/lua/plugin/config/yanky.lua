vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", {})
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", {})
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", {})
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", {})
vim.keymap.set("n", "<c-m>", "<Plug>(YankyCycleForward)", {})
vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)", {})

require("yanky").setup({})
