local plugin_name = "nvim-navic"

local function loading()
  local symbol_map = {}
  for key, value in pairs(require("lspkind").symbol_map) do
    symbol_map[value] = key .. " "
  end
  require(plugin_name).setup({
    icons = symbol_map,
    highlight = false,
    separator = " > ",
    depth_limit = 0,
    depth_limit_indicator = "..",
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
