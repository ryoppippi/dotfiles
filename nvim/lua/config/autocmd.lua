local restoreCursor = vim.api.nvim_create_augroup("restoreCursor", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local ml = vim.fn.line([['"]])
		local eol = vim.fn.line("$")
		if 1 < ml and ml <= eol then
			vim.cmd.normal([[g`"]])
		end
	end,
	group = restoreCursor,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
	callback = function()
		local wh = vim.fn.winheight(0)
		local cl = vim.fn.line(".")
		if tb(vim.fn.empty(vim.bo.buftype)) and cl > wh / 3 * 2 then
			vim.cmd.normal("zz")
			for _ = 0, (wh / 6) do
				vim.cmd.normal(t("<C-y>"))
			end
		end
	end,
	group = restoreCursor,
})

local augroup = vim.api.nvim_create_augroup("numbertoggle", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
	pattern = "*",
	group = augroup,
	callback = function()
		if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
			vim.opt.relativenumber = true
			vim.opt.cursorline = true
			vim.opt.cursorcolumn = true
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
	pattern = "*",
	group = augroup,
	callback = function()
		if vim.o.nu then
			vim.opt.relativenumber = false
			vim.opt.cursorline = true
			vim.opt.cursorcolumn = false
			vim.cmd("redraw")
		end
	end,
})

-- Idle timer: fires User IdleTick event every 1000ms while cursor is idle
local idle_timer_group = vim.api.nvim_create_augroup("idle_timer", { clear = true })
local idle_timer = vim.uv.new_timer()

local function stop_idle_timer()
	if idle_timer:is_active() then
		idle_timer:stop()
	end
end

local function start_idle_timer()
	stop_idle_timer()
	idle_timer:start(
		1000,
		1000,
		vim.schedule_wrap(function()
			if vim.fn.mode() ~= "c" and vim.api.nvim_get_mode().blocking == false then
				vim.api.nvim_exec_autocmds("User", { pattern = "IdleTick" })
			end
		end)
	)
end

-- Start timer on CursorHold
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	pattern = "*",
	group = idle_timer_group,
	callback = start_idle_timer,
	desc = "Start idle timer on CursorHold",
})

-- Stop timer when cursor moves or mode changes
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter", "InsertLeave", "CmdlineEnter" }, {
	pattern = "*",
	group = idle_timer_group,
	callback = stop_idle_timer,
	desc = "Stop idle timer on cursor move",
})

-- Check if file is modified on various events including IdleTick
local function checktime_if_safe()
	if vim.fn.mode() ~= "c" then
		vim.cmd.checktime()
	end
end

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "CursorHold", "CursorHoldI", "WinEnter" }, {
	pattern = "*",
	callback = checktime_if_safe,
	desc = "check if file is modified",
})

vim.api.nvim_create_autocmd("User", {
	pattern = "IdleTick",
	callback = checktime_if_safe,
	desc = "check if file is modified on idle tick",
})

vim.api.nvim_create_autocmd("Filetype", {
	pattern = "*",
	callback = function()
		vim.opt_local.fo:remove({ "c", "r", "o" })
	end,
	desc = "disable comment in newline",
})

local folding = vim.api.nvim_create_augroup("folding", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost", "BufNewFile" }, {
	pattern = "*",
	callback = function()
		vim.defer_fn(function()
			vim.cmd.normal("zR")
		end, 0)
	end,
	group = folding,
})

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	callback = function()
		vim.cmd.startinsert()
	end,
})

local restore_terminal_mode = vim.api.nvim_create_augroup("restore_terminal_mode", { clear = true })
vim.api.nvim_create_autocmd({ "TermEnter", "TermLeave" }, {
	pattern = "term://*",
	callback = function()
		vim.b.term_mode = vim.fn.mode()
	end,
	group = restore_terminal_mode,
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "term://*",
	callback = function()
		if vim.b.term_mode == "t" then
			vim.cmd.startinsert()
		end
	end,
	group = restore_terminal_mode,
})

vim.api.nvim_create_autocmd("CmdlineEnter", {
	callback = function()
		if tb(vim.fn.executable("ugrep")) then
			vim.opt.grepprg = "ugrep -RInk -j -u --tabs=1 --ignore-files"
			vim.opt.grepformat = "%f:%l:%c:%m,%f+%l+%c+%m,%-G%f\\|%l\\|%c\\|%m"
		end
	end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
	pattern = "c:*",
	callback = function()
		local cmd = vim.fn.histget(":", -1)
		if cmd ~= nil and (cmd == "x" or cmd == "xa" or cmd:match("^w?q?a?!?$")) then
			vim.fn.histdel(":", -1)
		end
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function(args)
		vim.g.colors_name = args.match
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function(args)
		vim.schedule(function()
			vim.g.colorterm = os.getenv("COLORTERM")
			if
				vim.tbl_contains({ "truecolor", "24bit", "rxvt", "" }, vim.g.colorterm)
				and tb(vim.fn.exists("+termguicolors"))
				and not is_vscode()
			then
				vim.o.termguicolors = true
				vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
			end
		end)
	end,
})
