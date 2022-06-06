local plugin_name = "kanagawa"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  local default_colors = require(plugin_name .. ".colors").setup()
  require(plugin_name).setup({
    overrides = {
      rainbowcol1 = { fg = default_colors.br },
    },
    globalStatus = true,
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
