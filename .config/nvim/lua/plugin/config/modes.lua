local plugin_name = "modes"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  require(plugin_name).setup()
  vim.opt.cursorline = true
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
