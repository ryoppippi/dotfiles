local plugin_name = "gruvbox-material"
if not require("utils.plugin").is_exists(plugin_name) then
	return
end

local function loading()
	vim.api.nvim_exec(
		[[
    if has('termguicolors')
      set termguicolors
    endif
    set background=dark
    let g:gruvbox_material_background = 'hard'
    let g:gruvbox_material_better_performance = 1
    let g:gruvbox_material_transparent_background = 1
    let g:gruvbox_material_enable_italic = 1
    let g:gruvbox_material_enable_bold = 1
    let g:gruvbox_material_disable_italic_comment = 0
    
    function! s:cs(timer)
      silent colorscheme gruvbox-material
    endfunction

    if !exists('g:gruvbox_set')
      let g:gruvbox_set = 1
      call timer_start(1, function('s:cs'))
    endif
  ]],
		false
	)
end

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = plugin_name,
	callback = loading,
})
