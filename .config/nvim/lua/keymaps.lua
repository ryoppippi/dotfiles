local t = require("utils").t

vim.g.mapleader = t("<Space>")
vim.g.completion_trigger_character = "."

vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set("n", ":", ";", { noremap = true })

-- hjkl
vim.keymap.set({ "n", "x" }, "j", function()
	return vim.v.count > 0 and "j" or "gj"
end, { noremap = true, expr = true })
vim.keymap.set({ "n", "x" }, "k", function()
	return vim.v.count > 0 and "k" or "gk"
end, { noremap = true, expr = true })

vim.keymap.set({ "n", "v" }, "H", "^", { noremap = true })
vim.keymap.set({ "n", "v" }, "L", "$", { noremap = true })
vim.keymap.set("n", "J", "<Nop>", { noremap = true })
vim.keymap.set("n", "K", "<Nop>", { noremap = true })
vim.keymap.set("n", "gh", "<Nop>", { noremap = true })
vim.keymap.set("n", "gj", "<Nop>", { noremap = true })
vim.keymap.set("n", "gk", "<Nop>", { noremap = true })
vim.keymap.set("n", "gl", "<Nop>", { noremap = true })

-- remap H M L
vim.keymap.set("n", "gH", "H", { noremap = true })
vim.keymap.set("n", "gM", "M", { noremap = true })
vim.keymap.set("n", "gL", "L", { noremap = true })
-- vim.keymap.set("n", "H", "<Nop>", { noremap = true })
-- vim.keymap.set("n", "M", "<Nop>", { noremap = true })
-- vim.keymap.set("n", "L", "<Nop>", { noremap = true })

-- split window
vim.keymap.set("n", "ss", "<cmd>split<cr><C-w>w", { noremap = true })
vim.keymap.set("n", "sv", "<cmd>vsplit<cr><C-w>w", { noremap = true })

-- move window
vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sl", "<C-w>l")
-- vim.keymap.set("n", "H", "<C-w>h")
-- vim.keymap.set("n", "J", "<C-w>j")
-- vim.keymap.set("n", "K", "<C-w>k")
-- vim.keymap.set("n", "L", "<C-w>l")

-- tab management
vim.keymap.set("n", "tt", "<cmd>tabe .<cr>", { noremap = true })
vim.keymap.set("n", "tk", "<cmd>tabnext<cr>", { noremap = true })
vim.keymap.set("n", "tj", "<cmd>tabprevious<cr>", { noremap = true })
vim.keymap.set("n", "th", "<cmd>tabfirst<cr>", { noremap = true })
vim.keymap.set("n", "tl", "<cmd>tablast<cr>", { noremap = true })
vim.keymap.set("n", "tq", "<cmd>tabclose<cr>", { noremap = true })

-- jj -> <ESC>
vim.keymap.set("i", "jj", "<Esc>", { noremap = true })

-- disable s because s = cl
vim.keymap.set("n", "s", "<Nop>", { noremap = true })

-- tips
vim.keymap.set("n", "Y", "y$", { noremap = true })
vim.keymap.set({ "n", "v" }, "x", '"_x', { noremap = true })
vim.keymap.set({ "n", "v" }, "X", '"_d$', { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>cclose<cr>", { noremap = true })
vim.keymap.set("n", "<C-l>", ":nohlsearch<CR><Esc>", { noremap = true })
vim.keymap.set("n", "<leader>p", "o<esc>p<esc>", { noremap = true })
