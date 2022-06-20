local plugin_name = "vgit"

local function loading()
  require("vgit").setup()
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
