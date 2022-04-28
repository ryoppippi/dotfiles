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
    " let g:gruvbox_material_transparent_background = 1
    let g:gruvbox_material_enable_italic = 1
    let g:gruvbox_material_enable_bold = 1
    let g:gruvbox_material_disable_italic_comment = 0
  ]],
    false
  )
end

loading()
