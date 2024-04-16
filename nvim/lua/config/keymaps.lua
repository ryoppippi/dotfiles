vim.g.completion_trigger_character = "."

vim.keymap.set("n", ";", ":")
vim.keymap.set("n", ":", ";")

-- hjkl
vim.keymap.set({ "n", "x" }, "j", function()
	if vim.v.count > 0 or #vim.fn.reg_recording() > 0 or #vim.fn.reg_executing() > 0 then
		return "j"
	end
	return "gj"
end, { expr = true })
vim.keymap.set({ "n", "x" }, "k", function()
	if vim.v.count > 0 or #vim.fn.reg_recording() > 0 or #vim.fn.reg_executing() > 0 then
		return "k"
	end
	return "gk"
end, { expr = true })

-- disable keys
-- vim.keymap.set("n", "H", "<Nop>")
-- vim.keymap.set("n", "J", "<Nop>")
-- vim.keymap.set("n", "K", "<Nop>")
-- vim.keymap.set("n", "L", "<Nop>")
vim.keymap.set({ "n", "v" }, "s", "<Nop>")
vim.keymap.set({ "n", "v" }, "S", "<Nop>")

vim.keymap.set("n", "gh", "<Nop>")
vim.keymap.set("n", "gj", "<Nop>")
vim.keymap.set("n", "gk", "<Nop>")
vim.keymap.set("n", "gl", "<Nop>")

-- remap H M L
vim.keymap.set("n", "gH", "H")
vim.keymap.set("n", "gM", "M")
vim.keymap.set("n", "gL", "L")

-- split window
vim.keymap.set("n", "ss", "<cmd>split<cr>")
vim.keymap.set("n", "sv", "<cmd>vsplit<cr>")

-- move window
vim.keymap.set("n", "sh", "<C-w>h")
vim.keymap.set("n", "sj", "<C-w>j")
vim.keymap.set("n", "sk", "<C-w>k")
vim.keymap.set("n", "sl", "<C-w>l")

-- tab management
vim.keymap.set("n", "<tab>", "<cmd>tabnext<cr>", { silent = true })
vim.keymap.set("n", "<s-tab>", "<cmd>tabprevious<cr>", { silent = true })
vim.keymap.set("n", "th", "<cmd>tabfirst<cr>", { silent = true })
vim.keymap.set("n", "tj", "<cmd>tabprevious<cr>", { silent = true })
vim.keymap.set("n", "tk", "<cmd>tabnext<cr>", { silent = true })
vim.keymap.set("n", "tl", "<cmd>tablast<cr>", { silent = true })
vim.keymap.set("n", "tt", "<cmd>tabe .<cr>", { silent = true })
vim.keymap.set("n", "tq", "<cmd>tabclose<cr>", { silent = true })

-- jj -> <ESC>
vim.keymap.set("i", "jj", "<Esc>")

-- arrow key prevent stopping undo block
-- vim.keymap.set("i", "<Left>", "<C-g>u<Left>")
-- vim.keymap.set("i", "<Right>", "<C-g>u<Right>")

-- disable s because s = cl
vim.keymap.set("n", "s", "<Nop>")

-- terminal mode
vim.keymap.set("t", [[<ESC>]], [[<C-\><C-n>]])

-- command mode
--- Emacs style from yutkat
vim.keymap.set("c", "<C-a>", "<Home>", { silent = false })
if not vim.g.vscode then
	vim.keymap.set("c", "<C-e>", "<End>", { silent = false })
end
vim.keymap.set("c", "<C-f>", "<right>", { silent = false })
vim.keymap.set("c", "<C-b>", "<left>", { silent = false })
vim.keymap.set("c", "<C-d>", "<DEL>", { silent = false })

-- regexp
vim.keymap.set("x", "<leader>r", 'y:%s/<C-r><C-r>"//g<Left><Left>')
vim.keymap.set("n", "<leader>r", 'yiw:%s/<C-r><C-r>"//g<Left><Left>')

-- toggle 0 made by ycino
vim.keymap.set("n", "0", function()
	return string.match((vim.fn.getline(".") --[[@as string]]):sub(0, vim.fn.col(".") - 1), "^%s+$") and "0"
		or "^"
end, { expr = true, silent = true })

-- Automatically indent with i and A made by ycino
vim.keymap.set("n", "i", function()
	return vim.fn.len(vim.fn.getline(".")) ~= 0 and "i" or '"_cc'
end, { expr = true, silent = true })
vim.keymap.set("n", "A", function()
	return vim.fn.len(vim.fn.getline(".")) ~= 0 and "A" or '"_cc'
end, { expr = true, silent = true })

vim.keymap.set(
	{ "n", "v" },
	"<leader>b",
	vim.fn.maparg("gx", "n", false, true).callback,
	{ desc = "Open URL under cursor in browser" }
)
vim.keymap.del({ "n", "v" }, "gx")

-- custom
-- vim.keymap.set("n", "<leader>ss", vim.cmd.ToggleStatusBar)

-- tips
-- vim.keymap.set({ "n", "v" }, "gy", '"+y') -- yank to clipboard
vim.keymap.set("n", "Y", "y$") -- yank to end of line
-- vim.keymap.set("n", "gY", '"+y$') -- yank to end of line and to clipboard
vim.keymap.set({ "n", "v" }, "x", '"_x') -- delete without yank
vim.keymap.set({ "n", "v" }, "X", '"_d$') -- delete to end of line without yank
vim.keymap.set({ "n", "v" }, "<leader>x", vim.cmd.cclose)
vim.keymap.set("n", "<C-l>", "<cmd>nohlsearch<cr><esc>")
vim.keymap.set("n", "gq", "<cmd>nohlsearch<cr><esc>")
vim.keymap.set("n", "<leader>a", "ggVG")

vim.keymap.set("", "<c-i>", "<c-i>")
