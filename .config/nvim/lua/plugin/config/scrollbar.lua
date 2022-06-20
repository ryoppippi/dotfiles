local plugin_name = "scrollbar"

local function loading()
  require("scrollbar.handlers.search").setup()
  require(plugin_name).setup({
    handlers = {
      diagnostic = true,
      search = true,
    },
    handle = {
      color = "#63768A",
    },
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
