local plugin_name = "commentary"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  vim.keymap.set({ "n", "x", "o" }, "gc", "<Plug>VSCodeCommentary")
  vim.keymap.set({ "n", "x", "o" }, "gcc", "<Plug>VSCodeCommentaryLine")
end

loading()
