local plugin_name = "gruvbox-material"

local function loading()
  vim.api.nvim_exec(
    [[
    if has('termguicolors')
      set termguicolors
    endif
    set background=dark
    let g:gruvbox_material_background = 'soft'
    let g:gruvbox_material_better_performance = 1
    let g:gruvbox_material_transparent_background = 1
    let g:gruvbox_material_enable_italic = 1
    let g:gruvbox_material_enable_bold = 1
    let g:gruvbox_material_disable_italic_comment = 0
    autocmd ColorScheme gruvbox-material hi DiagnosticWarn guifg=#ffb86c
    packadd gruvbox-material
  ]],
    false
  )
end

require("utils.plugin").pre_load(plugin_name, loading)
