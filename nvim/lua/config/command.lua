-- open config
vim.api.nvim_create_user_command("Config", function()
	vim.cmd.e(vim.fn.stdpath("config"))
end, { nargs = 0 })

vim.api.nvim_create_user_command("ConfigFiles", function()
	Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { nargs = 0 })

vim.api.nvim_create_user_command("EncodingReload", "execute 'e ++enc=<args>'", { force = true, nargs = 1 })

-- count word
vim.api.nvim_create_user_command("CountWord", function()
	local input = vim.fn.input("", "':%s/\\<<C-r><C-w>\\>/&/gn'")
	vim.cmd(input)
	vim.fn.histadd("cmd", input)
end, { force = true })

vim.api.nvim_create_user_command("ToggleStatusBar", function()
	if vim.o.laststatus == 3 then
		vim.opt.laststatus = 0
	else
		vim.opt.laststatus = 3
	end
end, { nargs = 0, force = true })

-- sort startuptime
vim.api.nvim_create_user_command("SortStartupTime", "%!sort -k2nr", { force = true })

vim.api.nvim_create_user_command("ToggleCursorline", function()
	vim.wo.cursorline = not vim.wo.cursorline
	vim.wo.cursorcolumn = not vim.wo.cursorcolumn
end, { nargs = 0, force = true })

vim.api.nvim_create_user_command("CopyPath", function(opts)
	local path
	if opts.bang then
		path = vim.fn.expand("%:.")
	else
		path = vim.fn.expand("%:p")
	end
	vim.fn.setreg("+", path)
	vim.notify("Copied: " .. path)
end, { nargs = 0, bang = true, force = true })

vim.api.nvim_create_user_command("QuickLook", function()
	-- get current buffer absolute path
	local path = vim.fn.expand("%:p")

	require("core.utils").open_file_with_quicklook(path)
end, { nargs = 0, force = true })
