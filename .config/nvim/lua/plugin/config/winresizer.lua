local plugin_name = "winresizer"

local function loading()
  vim.g.winresizer_enable = 1
  vim.keymap.set("n", "<leader>ww", "<cmd>WinResizerStartResize<cr>", {  silent = true })
end

require("utils.plugin").post_load(plugin_name, loading)
