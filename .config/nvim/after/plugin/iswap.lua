local plugin_name = "iswap"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  require(plugin_name).setup()
end

loading()
