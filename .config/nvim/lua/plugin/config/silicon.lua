local plugin_name = "vim-silicon"

local function loading()
  vim.g.silicon = {
    theme = "gruvbox",
  }
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
