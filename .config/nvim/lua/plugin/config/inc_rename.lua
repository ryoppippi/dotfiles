local plugin_name = "inc_rename"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  local tb = require("utils").toboolean
  if tb(vim.fn.has("nvim-0.8")) then
    require(plugin_name).setup()
  end
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
