local restoreCursor = vim.api.nvim_create_augroup("restoreCursor", { clear = true })
vim.api.nvim_create_autocmd("BufReadPost", {
  command = [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif]],
  group = restoreCursor,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  command = [[
  if empty(&buftype) && line('.') > winheight(0) / 3 * 2|   execute 'normal! zz' .. repeat("\<C-y>", winheight(0) / 6)| endif
  ]],
  group = restoreCursor,
})

vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  command = "startinsert",
})

local folding = vim.api.nvim_create_augroup("folding", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPost", "FileReadPost", "BufNewFile" }, {
  pattern = "*",
  callback = function()
    vim.defer_fn(function()
      vim.cmd([[normal zR]])
    end, 0)
  end,
  group = folding,
})

vim.api.nvim_exec(
  [[
  augroup vimrc_syntax
  autocmd!
  highlight default ExtraWhitespace ctermbg=darkmagenta guibg=darkmagenta

  " visualize whitespace characters
  " u2000 ' ' en quad
  " u2001 ' ' em quad
  " u2002 ' ' en space
  " u2003 ' ' em space
  " u2004 ' ' three-per em space
  " u2005 ' ' four-per em space
  " u2006 ' ' six-per em space
  " u2007 ' ' figure space
  " u2008 ' ' punctuation space
  " u2009 ' ' thin space
  " u200A ' ' hair space
  " u200B '​' zero-width space
  " u3000 '　' ideographic (zenkaku) space
  autocmd VimEnter,WinEnter,BufRead *
        \ call matchadd('ExtraWhitespace', "[\u2000-\u200B\u3000]")
augroup END
]],
  true
)

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
      vim.cmd([[startinsert!]])
    end
  end,
  group = restore_terminal_mode,
})
