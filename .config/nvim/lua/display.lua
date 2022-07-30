vim.g.colorterm = os.getenv("COLORTERM")
if vim.tbl_contains({ "truecolor", "24bit", "rxvt", "" }, vim.g.colorterm) then
  if tb(vim.fn.exists("+termguicolors")) then
    vim.o.t_8f = "<Esc>[38;2;%lu;%lu;%lum"
    vim.o.t_8b = "<Esc>[48;2;%lu;%lu;%lum"
    vim.o.termguicolors = true
    vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
  end
end

vim.opt.list = true
vim.opt.laststatus = 3
if tb(vim.fn.has("nvim-0.8")) then
  vim.opt.cmdheight = 0
  -- vim.opt.laststatus = 0
end

vim.opt.listchars = {
  tab = "▸▹┊",
  trail = "▫",
  extends = "❯",
  precedes = "❮",
}

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.o.termguicolors then
      pcall(vim.cmd, [[silent colorscheme kanagawa]])
    end
  end,
  once = true,
})
