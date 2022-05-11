local plugin_name = "vim-expand-region"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  -- vmap v <Plug>(expand_region_expand)
  -- vmap <C-v> <Plug>(expand_region_shrink)
  vim.keymap.set("v", "v", "<Plug>(expand_region_expand)")
  vim.keymap.set("v", "<C-v>", "<Plug>(expand_region_shrink)")
end

loading()
