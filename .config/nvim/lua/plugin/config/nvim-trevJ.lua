local plugin_name = "trevj"

local function loading()
  local status, trevj = pcall(require, "trevj")
  if not status then
    return
  end
  trevj.setup()
  vim.keymap.set("n", "<leader>j", function()
    trevj.format_at_cursor()
  end)
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
