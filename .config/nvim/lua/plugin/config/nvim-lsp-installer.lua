local plugin_name = "nvim-lsp-installer"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end
local M = {}

function M.config()
  vim.cmd(string.format("packadd %s", plugin_name))
  require(plugin_name).setup({
    ui = {
      icons = {
        server_installed = "✓",
        server_pending = "➜",
        server_uninstalled = "✗",
      },
    },
  })
end

return M
