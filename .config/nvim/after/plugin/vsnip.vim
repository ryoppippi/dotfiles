" if !exists('g:loaded_vsnip') | finish | endif

let g:vsnip_snippet_dir = stdpath('config') .. '/my_vscode_snippets/snippets'

let g:vsnip_filetypes = {}
let g:vsnip_filetypes.javascriptreact = ['javascript']
let g:vsnip_filetypes.typescriptreact = ['typescript']

