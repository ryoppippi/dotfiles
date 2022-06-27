local plugin_name = "treesitter-unit"

local function loading()
  vim.keymap.set({ "x", "o" }, "iu", ':lua require"treesitter-unit".select()<CR>')
  vim.keymap.set({ "x", "o" }, "au", ':lua require"treesitter-unit".select(true)<CR>')
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
