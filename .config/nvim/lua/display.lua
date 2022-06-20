local function setting()
  local tb = require("utils").toboolean
  vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
  pcall(vim.cmd, [[silent colorscheme kanagawa]])

  vim.g.colorterm = os.getenv("COLORTERM")
  if
    vim.g.colorterm == "truecolor"
    or vim.g.colorterm == "24bit"
    or vim.g.colorterm == "rxvt"
    or vim.g.colorterm == ""
  then
    if vim.fn.exists("+termguicolors") then
      vim.o.t_8f = "<Esc>[38;2;%lu;%lu;%lum"
      vim.o.t_8b = "<Esc>[48;2;%lu;%lu;%lum"
      vim.o.termguicolors = true
    end
  end
  if vim.g.termguicolors then
    vim.opt.termguicolors = true
  end

  vim.opt.list = true
  vim.opt.laststatus = 3
  if tb(vim.fn.has("nvim-0.8")) then
    -- vim.opt.cmdheight = 0
    -- vim.opt.laststatus = 0
  end

  vim.opt.listchars = {
    -- space = "",
    tab = "▸▹┊",
    trail = "▫",
    extends = "❯",
    precedes = "❮",
  }
end
vim.api.nvim_create_autocmd("VimEnter", {
  callback = setting,
  once = true,
  nested = true,
})
