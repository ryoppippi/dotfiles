local plugin_name = "colorizer"

local function loading()
  require(plugin_name).setup()
  pcall(vim.cmd, [[ColorizerToggle]])
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
