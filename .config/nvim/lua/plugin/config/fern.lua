vim.cmd([[
  nnoremap <silent> <Leader>e :Fern . -reveal=%<CR>
  nnoremap <silent> <Leader>E :Fern . -reveal=% -drawer -toggle -width=40<CR>

  let g:fern#default_hidden = v:true
  " let g:fern#keepjumps_on_edit = 1
  " let g:fern#keepalt_on_edit = 1
  let g:fern#drawer_keep =1
  " let g:fern_auto_preview = v:true
  let g:fern#renderer = 'nerdfont'


  function! s:fern_settings() abort
    nmap <silent> <buffer> p     <Plug>(fern-action-preview:toggle)
    nmap <silent> <buffer> <C-p> <Plug>(fern-action-preview:auto:toggle)
    nmap <silent> <buffer> T <Plug>(fern-action-open:edit-or-tabedit)
    nmap <silent> <buffer> t <Nop>
    nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
    nmap <silent> <buffer> <C-f> <Plug>(fern-action-preview:scroll:up:half)
    nmap <silent> <buffer> <expr> <Plug>(fern-quit-or-close-preview) fern_preview#smart_preview("\<Plug>(fern-action-preview:close)", ":q\<CR>")
    nmap <silent> <buffer> q <Plug>(fern-quit-or-close-preview)
  endfunction

  augroup my-glyph-palette
    autocmd! *
    autocmd FileType fern call glyph_palette#apply()
    autocmd FileType nerdtree,startify call glyph_palette#apply()
  augroup END

  augroup fern-custom
    autocmd! *
    autocmd FileType fern call s:fern_settings()
  augroup END
]])
