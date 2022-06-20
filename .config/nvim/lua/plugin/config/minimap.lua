local plugin_name = "minimap"

local function loading()
  -- let g:minimap_width = 10
  -- let g:minimap_auto_start = 0
  -- let g:minimap_auto_start_win_enter = 0
  vim.g.minimap_width = 10
  vim.g.minimap_auto_start = 0
  vim.g.minimap_auto_start_win_enter = 0
end

loading()
