local plugin_name = "mkdx"

local function loading()
  vim.g["mkdx#settings"] = {}
end

require("utils.plugin").pre_load(plugin_name, loading)
