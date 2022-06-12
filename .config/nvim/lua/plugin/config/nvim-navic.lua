local plugin_name = "nvim_navic"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
-- stylua: ignore
require(plugin_name).setup {
    icons = require('lspkind').symbol_map,
    highlight = false,
    separator = " > ",
    depth_limit = 0,
    depth_limit_indicator = "..",
}
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
