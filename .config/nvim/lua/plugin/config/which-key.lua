local plugin_name = "which-key"

local function loading()
  require(plugin_name).setup({
    plugins = {
      registers = false,
    },
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
