if !exists('g:loaded_copilot') | finish | endif

" https://github.com/LunarVim/LunarVim/discussions/1947
if g:enable_cmp
  let g:copilot_no_tab_map=v:true
  let g:copilot_assume_mapped=v:true
  let g:copilot_tab_fallback=""
endif

if g:enable_ddc
  let g:copilot_no_tab_map=v:true
  let g:copilot_assume_mapped=v:true
  let g:copilot_tab_fallback=""
endif

if g:enable_cmp
  let g:copilot_no_tab_map=v:true
  let g:copilot_assume_mapped=v:true
  let g:copilot_tab_fallback=""
  imap <script> <nowait> <expr> <C-%> copilot#Accept("\<TAB>")
endif

let g:copilot_filetypes = {
  \'*':v:true,
  \ }

imap <silent><script><nowait><expr> <C-l> copilot#Dismiss()
