local t = require("utils").t
local tb = require("utils").toboolean

vim.g.mapleader = t("<Space>")
vim.g.completion_trigger_character = "."

vim.keymap.set("n", ";", ":", { noremap = true })
vim.keymap.set("n", ":", ";", { noremap = true })

-- disable some keys
vim.keymap.set("n", "r", "<Nop>", { noremap = true })

-- hjkl
vim.keymap.set({ "n", "x" }, "j", function()
  if vim.v.count > 0 or #vim.fn.reg_recording() > 0 or #vim.fn.reg_executing() > 0 then
    return "j"
  end
  return "gj"
end, { noremap = true, expr = true })
vim.keymap.set({ "n", "x" }, "k", function()
  if vim.v.count > 0 or #vim.fn.reg_recording() > 0 or #vim.fn.reg_executing() > 0 then
    return "k"
  end
  return "gk"
end, { noremap = true, expr = true })

vim.keymap.set("n", "H", "<Nop>", { noremap = true })
vim.keymap.set("n", "J", "<Nop>", { noremap = true })
vim.keymap.set("n", "K", "<Nop>", { noremap = true })
vim.keymap.set("n", "L", "<Nop>", { noremap = true })
vim.keymap.set("n", "gh", "<Nop>", { noremap = true })
vim.keymap.set("n", "gj", "<Nop>", { noremap = true })
vim.keymap.set("n", "gk", "<Nop>", { noremap = true })
vim.keymap.set("n", "gl", "<Nop>", { noremap = true })

-- remap H M L
vim.keymap.set("n", "gH", "H", { noremap = true })
vim.keymap.set("n", "gM", "M", { noremap = true })
vim.keymap.set("n", "gL", "L", { noremap = true })

-- split window
vim.keymap.set("n", "ss", "<cmd>split<cr><C-w>w", { noremap = true })
vim.keymap.set("n", "sv", "<cmd>vsplit<cr><C-w>w", { noremap = true })

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

-- jj -> <ESC>
vim.keymap.set("i", "jj", "<Esc>", { noremap = true })

-- disable s because s = cl
vim.keymap.set("n", "s", "<Nop>", { noremap = true })

-- terminal mode
vim.keymap.set("t", [[<ESC>]], [[<C-\><C-n>]], { noremap = true })

-- command mode
--- Emacs style from yutkat
vim.keymap.set("c", "<C-a>", "<Home>", { noremap = true, silent = false })
if not vim.g.vscode then
  vim.keymap.set("c", "<C-e>", "<End>", { noremap = true, silent = false })
end
vim.keymap.set("c", "<C-f>", "<right>", { noremap = true, silent = false })
vim.keymap.set("c", "<C-b>", "<left>", { noremap = true, silent = false })
vim.keymap.set("c", "<C-d>", "<DEL>", { noremap = true, silent = false })

-- tips
vim.keymap.set("n", "Y", "y$", { noremap = true })
vim.keymap.set({ "n", "v" }, "x", '"_x', { noremap = true })
vim.keymap.set({ "n", "v" }, "X", '"_d$', { noremap = true })
vim.keymap.set({ "n", "v" }, "<leader>cc", "<cmd>cclose<cr>", { noremap = true })
vim.keymap.set("n", "<C-l>", "<cmd>nohlsearch<cr><esc>", { noremap = true })
vim.keymap.set("n", "gq", "<cmd>nohlsearch<cr><esc>", { noremap = true })
vim.keymap.set("n", "<leader>p", 'o<esc>^"_d$p<esc>', { noremap = true })

-- toggle 0, ^ made by ycino
for _, key in ipairs({ "^", "0" }) do
  vim.keymap.set("n", key, function()
    return string.match(vim.fn.getline("."):sub(0, vim.fn.col(".") - 1), "^%s+$") and "0" or "^"
  end, { noremap = true, expr = true, silent = true })
end

-- Automatically indent with i and A made by ycino
vim.keymap.set("n", "i", function()
  return vim.fn.len(vim.fn.getline(".")) ~= 0 and "i" or '"_cc'
end, { noremap = true, expr = true, silent = true })
vim.keymap.set("n", "A", function()
  return vim.fn.len(vim.fn.getline(".")) ~= 0 and "A" or '"_cc'
end, { noremap = true, expr = true, silent = true })
