local plugin_name = "dial"
if not require("utils.plugin").is_exists(plugin_name) then
	return
end

local function setup()
	vim.api.nvim_exec(
		[[
  nmap  <C-a>  <Plug>(dps-dial-increment)
  nmap  <C-x>  <Plug>(dps-dial-decrement)
  xmap  <C-a>  <Plug>(dps-dial-increment)
  xmap  <C-x>  <Plug>(dps-dial-decrement)
  xmap g<C-a> g<Plug>(dps-dial-increment)
  xmap g<C-x> g<Plug>(dps-dial-decrement)

  let g:dps_dial#augends = [
  \   'decimal',
  \   'date-slash',
  \   {'kind': 'constant', 'opts': {'elements': ['true', 'false']}},
  \   {'kind': 'case', 'opts': {'cases': ['camelCase', 'snake_case'], 'cyclic': v:true}},
  \ ]

  function! MarkdownHeaderFind(line, cursor)
  let match = matchstr(a:line, '^#\+')
  if match !=# ''
    return {"from": 0, "to": strlen(match)}
    endif
    return v:null
    endfunction

    function! MarkdownHeaderAdd(text, addend, cursor)
    let n_header = strlen(a:text)
    let n_header = min([6, max([1, n_header + a:addend])])
    let text = repeat('#', n_header)
    let cursor = 1
    return {'text': text, 'cursor': cursor}
    endfunction

    let s:id_find = dps_dial#register_callback(function("MarkdownHeaderFind"))
      let s:id_add = dps_dial#register_callback(function("MarkdownHeaderAdd"))

    augroup dps-dial
      autocmd FileType markdown let b:dps_dial_augends_register_h = [ {"kind": "user", "opts": {"find": s:id_find, "add": s:id_add}} ]
      autocmd FileType python let b:dps_dial#augends = ['decimal', {'kind': 'constant', 'opts': {'elements': ['True', 'False']}}]
      autocmd FileType markdown nmap <buffer> <Space>a "h<Plug>(dps-dial-increment)
      autocmd FileType markdown nmap <buffer> <Space>x "h<Plug>(dps-dial-decrement)
      autocmd FileType markdown vmap <buffer> <Space>a "h<Plug>(dps-dial-increment)
      autocmd FileType markdown vmap <buffer> <Space>x "h<Plug>(dps-dial-decrement)
    augroup END
    ]],
		true
	)
end

require("utils.plugin").load_denops_plugin(plugin_name, setup)
