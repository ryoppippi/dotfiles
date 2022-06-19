local plugin_name = "mkdx"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  vim.g["mkdx#settings"] = {}
end

require("utils.plugin").pre_load(plugin_name, loading)
