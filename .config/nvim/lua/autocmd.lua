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

-- execute timer and dautocmd
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local function dautocmd()
      vim.api.nvim_exec_autocmds("User", {
        pattern = "VimLoaded",
      })
    end
    vim.defer_fn(dautocmd, 200)
  end,
})
