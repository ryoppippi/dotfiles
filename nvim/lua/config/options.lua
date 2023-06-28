vim.g.mapleader = t("<Space>")

vim.opt.backup = true
vim.opt.backupdir = vim.fn.expand(vim.fn.stdpath("cache") .. "/.vim_backup")
vim.opt.swapfile = false
vim.opt.writebackup = true
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.mouse = "a"

vim.opt.wrap = false
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.virtualedit = "onemore"
vim.opt.visualbell = true
vim.opt.showmatch = true
vim.opt.showcmd = true

-- vim.opt.splitright = true
-- vim.opt.splitbelow = true

vim.opt.fenc = "utf-8"
local tabwidth = 2
vim.opt.tabstop = tabwidth
vim.opt.softtabstop = tabwidth
vim.opt.shiftwidth = tabwidth
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.nrformats:remove({ "unsigned", "octal" })

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.wrapscan = true
vim.opt.wildmode = { list = "longest" }

vim.opt.errorbells = false
vim.opt.visualbell = false

vim.o.undolevels = 10000

vim.opt.list = true

vim.opt.listchars = {
	tab = "▸▹┊",
	trail = "▫",
	extends = "❯",
	precedes = "❮",
}

vim.g.colorterm = os.getenv("COLORTERM")
if
	vim.tbl_contains({ "truecolor", "24bit", "rxvt", "" }, vim.g.colorterm)
	and tb(vim.fn.exists("+termguicolors"))
	and not is_vscode()
then
	vim.o.t_8f = "<Esc>[38;2;%lu;%lu;%lum"
	vim.o.t_8b = "<Esc>[48;2;%lu;%lu;%lum"
	vim.o.termguicolors = true
	vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
end

vim.opt.laststatus = 0
vim.api.nvim_set_hl(0, "Statusline", { link = "Normal" })
vim.api.nvim_set_hl(0, "StatuslineNC", { link = "Normal" })
vim.opt.statusline = string.rep(" ", vim.api.nvim_win_get_width(0))

vim.opt.showcmd = false
