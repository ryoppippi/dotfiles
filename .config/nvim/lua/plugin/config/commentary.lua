local plugin_name = "commentary"

local function loading()
  vim.keymap.set({ "n", "x", "o" }, "gc", "<Plug>VSCodeCommentary")
  vim.keymap.set({ "n", "x", "o" }, "gcc", "<Plug>VSCodeCommentaryLine")
end

loading()
