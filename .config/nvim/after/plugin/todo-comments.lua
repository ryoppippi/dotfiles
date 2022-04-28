local plugin_name = "todo-comments"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  require(plugin_name).setup({
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
