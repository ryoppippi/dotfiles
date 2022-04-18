local t = require("utils").t
local is_vscode = require("utils").is_vscode

vim.g.mapleader = t("<Space>")
vim.g.completion_trigger_character = "."

vim.keymap.set("n", "<C-l>", ":nphlsearch<CR><Esc>", { noremap = true })

vim.keymap.set({ "n", "v" }, ";", ":", { noremap = true })
vim.keymap.set({ "n", "v" }, ":", ";", { noremap = true })

-- split window
if not is_vscode then
  vim.keymap.set("n", "ss", "<cmd>split<cr>")
  vim.keymap.set("n", "sv", "<cmd>vsplit<cr>")
else
  vim.keymap.set("n", "ss", "<cmd>split<cr><C-w>w")
  vim.keymap.set("n", "sv", "<cmd>vsplit<cr><C-w>w")
end

-- move window
vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sl", "<C-w>l")

-- tab management
vim.keymap.set("n", "tt", "<cmd>tabe .<cr>", { noremap = true })
vim.keymap.set("n", "tk", "<cmd>tabnext<cr>", { noremap = true })
vim.keymap.set("n", "tj", "<cmd>tabprevious<cr>", { noremap = true })
vim.keymap.set("n", "th", "<cmd>tabfirst<cr>", { noremap = true })
vim.keymap.set("n", "tl", "<cmd>tablast<cr>", { noremap = true })
vim.keymap.set("n", "tq", "<cmd>tabclose<cr>", { noremap = true })

-- 折り返し時に表示行単位での移動できるようにする
vim.keymap.set("n", "j", "gj", { noremap = true })
vim.keymap.set("n", "k", "gk", { noremap = true })

-- jj -> <ESC>
vim.keymap.set("i", "jj", "<Esc>", { noremap = true })

-- disable s because s = cl
vim.keymap.set("n", "s", "<Nop>", { noremap = true })
vim.keymap.set("n", "S", "<Nop>", { noremap = true })

-- noremap x "_x
-- nnoremap D "_D
