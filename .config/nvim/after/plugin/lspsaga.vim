if !exists('g:loaded_lspsaga') | finish | endif


lua << EOF
local saga = require 'lspsaga'

saga.setup( {
  use_saga_diagnostic_sign = true,
  error_sign = " ",
  warn_sign = " ",
  infor_sign = " ",
  hint_sign = "",
  border_style = "round",
})

EOF

nnoremap <silent> <C-j> :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> gh :Lspsaga hover_doc<CR>
" nnoremap <silent> gj :Lspsaga preview_definition<CR>
nnoremap <silent> gk :Lspsaga signature_help<CR>
nnoremap <silent> gK :Lspsaga lsp_finder<CR>

nnoremap <silent> gj :Lspsaga show_line_diagnostics<CR>
nnoremap <silent> - :Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> _ :Lspsaga diagnostic_jump_prev<CR>

nnoremap <silent> cW <cmd>lua require'lspsaga.rename'.rename()<CR>


nnoremap <silent> <leader>ag :Lspsaga open_floaterm lazygit<CR>
nnoremap <silent> <leader>aa :Lspsaga open_floaterm <CR>
nnoremap <silent> <leader>ac :Lspsaga close_floaterm<CR>
tnoremap <silent> <ESC> <C-\><C-n>:Lspsaga close_floaterm<CR>

" augroup lspsaga_filetypes
"   autocmd!
"   autocmd FileType LspsagaHover nnoremap <buffer><nowait><silent> <Esc> :q<cr>
" augroup END
