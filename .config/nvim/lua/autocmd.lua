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

vim.api.nvim_create_autocmd("Filetype", {
  pattern = "*",
  callback = function()
    vim.opt.fo:remove({ "c", "r", "o" })
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
  command = "startinsert",
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
