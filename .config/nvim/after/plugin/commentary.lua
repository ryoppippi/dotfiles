vim.api.nvim_exec(
  [[
if exists('g:loaded_commentary')
      xmap gc  <Plug>VSCodeCommentary
      nmap gc  <Plug>VSCodeCommentary
      omap gc  <Plug>VSCodeCommentary
      nmap gcc <Plug>VSCodeCommentaryLine
endif
]],
  true
)
