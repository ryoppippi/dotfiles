local plugin_name = "nvim-gps"

local function loading()
  require(plugin_name).setup({
    icons = {
      ["class-name"] = " ", -- Classes and class-like objects
      ["function-name"] = " ", -- Functions
      ["method-name"] = " ", -- Methods (functions inside class-like objects)
      ["container-name"] = "⛶ ", -- Containers (example: lua tables)
      ["tag-name"] = " ", -- Tags (example: html tags)
    },
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
