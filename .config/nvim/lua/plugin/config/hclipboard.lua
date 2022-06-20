local plugin_name = "hclipboard"

local function loading()
  require(plugin_name).start()
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
