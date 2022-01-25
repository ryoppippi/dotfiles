if !exists('g:loaded_lspsaga') | finish | endif

lua << EOF
local saga = require 'lspsaga'

saga.init_lsp_saga {
  error_sign = '',
  warn_sign = '',
  hint_sign = '',
  infor_sign = '',
  border_style = "round",
}

EOF

nnoremap <silent> <C-j> :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> gh <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
nnoremap <silent> gj :Lspsaga preview_definition<CR>
nnoremap <silent> gs :Lspsaga signature_help<CR>
nnoremap <silent> gf <cmd>Lspsaga lsp_finder<CR>

nnoremap <silent> <leader>lg <cmd>lua require('lspsaga.floaterm').open_float_terminal('lazygit')<CR>
nnoremap <silent> <leader>lt <cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR>
tnoremap <silent> <ESC> <C-\><C-n>:lua require('lspsaga.floaterm').close_float_terminal()<CR>

