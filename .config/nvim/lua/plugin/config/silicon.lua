local plugin_name = "vim-silicon"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  vim.g.silicon = {
    theme = "gruvbox",
  }
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
