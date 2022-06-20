local plugin_name = "nvim-navic"

local function loading()
  require(plugin_name).setup({
    icons = require("lspkind").symbol_map,
    highlight = false,
    separator = " > ",
    depth_limit = 0,
    depth_limit_indicator = "..",
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
