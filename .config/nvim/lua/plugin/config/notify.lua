local plugin_name = "notify"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  require("notify").setup({
    -- Icons for the different levels
    icons = {
      ERROR = "",
      WARN = "",
      INFO = "",
      DEBUG = "",
      TRACE = "✎",
    },
  })
  vim.notify = require("notify")
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
