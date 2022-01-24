if g:enable_ddc

  set completeopt=menuone,noselect

  call popup_preview#enable()
  " call signature_help#enable()

  " Customize global settings
  " Use around source.
  " https://github.com/Shougo/ddc-around
  call ddc#custom#patch_global('sources', [
        \ 'nvim-lsp',
        \ 'file',
        \ 'vsnip',
        \ 'tabnine',
        \ 'cmdline-history',
        \ 'cmdline',
        \ ])

  " Use matcher_head and sorter_rank.
  " https://github.com/Shougo/ddc-matcher_head
  " https://github.com/Shougo/ddc-sorter_rank
  call ddc#custom#patch_global('sourceOptions', {
          \ '_': {
          \   'matchers': ['matcher_fuzzy'],
          \   'sorters': ['sorter_fuzzy'],
          \   'converters': ['converter_fuzzy','converter_remove_overlap', 'converter_truncate'],
          \   'minAutoCompleteLength': 1,
          \ },
          \ 'vsnip': {
          \     'mark': 'vsnip',
          \     'dup': v:true,
          \ },
          \ 'nvim-lsp': {
          \     'mark': 'lsp',
          \     'forceCompletionPattern': '\.|:|->|"\w+/*',
          \ },
          \ 'tabnine': {
          \     'mark': 'TN',
          \     'maxCandidates': 5,
          \     'isVolatile': v:true,
          \ },
          \ 'file': {
          \     'mark': 'F',
          \ },
          \ })

  call ddc#custom#patch_global('sourceParams', {
        \ 'nvim-lsp': { 'kindLabels': { 'Class': 'c' } },
        \ })


  call ddc#custom#patch_global('completionMenu', 'pum.vim')


  " Mappings
  if exists('g:loaded_copilot')
    imap <silent> <expr> <TAB>  pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : vsnip#jumpable(+1) ? '<Plug>(vsnip-jump-next)' : copilot#Accept("<TAB>")
    imap <expr> <C-l> pum#visible() ? '<Cmd>call pum#map#cancel()<CR>' : '<CMD> call copilot#Dismiss()<CR>'
  else
    imap <silent> <expr> <TAB> pum#visible() ? '<Cmd>call pum#map#insert_relative(+1)<CR>' : vsnip#jumpable(+1) ? '<Plug>(vsnip-jump-next)' : '<TAB>'
    inoremap <C-l> <Cmd>call pum#map#cancel()<CR>
  endif
  imap <silent> <expr> <S-TAB> pum#visible() ? '<Cmd>call pum#map#insert_relative(-1)<CR>' : vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-TAB>'

  " inoremap <Tab> <Cmd>call pum#map#insert_relative(+1)<CR>
  inoremap <C-y> <Cmd>call pum#map#confirm()<CR>
  inoremap <expr> <CR> pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<CR>'


  " Use ddc.
  call ddc#enable()
  
autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)

  

endif
