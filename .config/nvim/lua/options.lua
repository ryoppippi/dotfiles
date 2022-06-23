-- setting
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0
vim.g.did_install_default_menus = 1
vim.g.did_install_syntax_menu = 1
vim.g.did_indent_on = 1
vim.g.did_load_ftplugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_man = 1
vim.opt.backup = true
vim.opt.backupdir = vim.fn.expand(os.getenv("HOME") .. "/.vim_backup")
vim.opt.swapfile = false
vim.opt.writebackup = true
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.mouse = "a"

vim.opt.wrap = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.virtualedit = "onemore"
vim.opt.visualbell = true
vim.opt.showmatch = true
vim.opt.showcmd = true

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

-- vim.g["denops#debug"] = true

vim.api.nvim_create_autocmd("CmdlineEnter", {
  callback = function()
    local tb = require("utils").toboolean
    if tb(vim.fn.executable("ugrep")) then
      vim.opt.grepprg = "ugrep -RInk -j -u --tabs=1 --ignore-files"
      vim.opt.grepformat = "%f:%l:%c:%m,%f+%l+%c+%m,%-G%f\\|%l\\|%c\\|%m"
    end
  end,
})
