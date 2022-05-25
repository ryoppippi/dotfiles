local plugin_name = "winresizer"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  vim.g.winresizer_enable = 1
  vim.keymap.set("n", "<leader>ww", "<cmd>WinResizerStartResize<cr>", { noremap = true, silent = true })
end

require("utils.plugin").post_load(plugin_name, loading)
