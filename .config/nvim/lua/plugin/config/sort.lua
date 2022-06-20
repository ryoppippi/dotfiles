local plugin_name = "sort"

local function loading()
  require(plugin_name).setup()
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
