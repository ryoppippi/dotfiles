function! s:load_plug(timer)

if g:enable_cmp || g:enable_ddc
  imap <expr> <Plug>(vimrc:copilot-dummy-map) copilot#Accept("\<Tab>")
  imap <expr> <C-h> copilot#Accept("\<CR>")
  let g:copilot_no_tab_map=v:true
  let g:copilot_assume_mapped=v:true
  let g:copilot_tab_fallback=""

  imap <silent><script><nowait><expr> <C-l> copilot#Dismiss()
endif

call plug#load(
            \ 'copilot',
            \ )
endfunction

call timer_start(20, function("s:load_plug"))

