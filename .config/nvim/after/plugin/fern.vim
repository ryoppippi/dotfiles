if !exists('g:loaded_fern') | finish | endif

nnoremap <silent> <Leader>e :Fern . -reveal=%<CR>
nnoremap <silent> <Leader>E :Fern %:h -reveal=%<CR>

" nnoremap <silent> <Leader>e :Fern . -reveal=% -drawer -toggle -width=40<CR>

function! s:fern_settings() abort
  nmap <silent> <buffer> g     <Plug>(fern-action-preview:toggle)
  nmap <silent> <buffer> <C-g> <Plug>(fern-action-preview:auto:toggle)
  nmap <silent> <buffer> <C-d> <Plug>(fern-action-preview:scroll:down:half)
  nmap <silent> <buffer> <C-f> <Plug>(fern-action-preview:scroll:up:half)
  nmap <silent> <buffer> <expr> <Plug>(fern-quit-or-close-preview) fern_preview#smart_preview("\<Plug>(fern-action-preview:close)", ":q\<CR>")
  nmap <silent> <buffer> q <Plug>(fern-quit-or-close-preview)
endfunction

augroup fern-settings
  autocmd!
  autocmd FileType fern call s:fern_settings()
augroup END

let g:fern#renderer = 'nerdfont'

augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END
