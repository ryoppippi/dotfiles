local plugin_name = "nvim-lsp-installer"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end
local M = {}

function M.config()
  local status, lspinstaller = require("utils.plugin").force_require(plugin_name)
  if status then
    lspinstaller.setup({
      ui = {
        icons = {
          server_installed = "✓",
          server_pending = "➜",
          server_uninstalled = "✗",
        },
      },
    })
  end
end

return M
