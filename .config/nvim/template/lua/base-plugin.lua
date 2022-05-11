local plugin_name = "{{_name_}}"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
-- stylua: ignore
  require(plugin_name).setup(){{_cursor_}}
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
