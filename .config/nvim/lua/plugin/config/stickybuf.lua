local plugin_name = "stickybuf"

local function loading()
  require(plugin_name).setup({
    filetype = {
      toggleterm = "filetype",
      lir = false,
    },
    autocmds = {
      lir = [[au FileType lir UnpinBuffer ]],
    },
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
