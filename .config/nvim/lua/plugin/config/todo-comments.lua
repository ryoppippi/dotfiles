local plugin_name = "todo-comments"

local function loading()
  require(plugin_name).setup({
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
