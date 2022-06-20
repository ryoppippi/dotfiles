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
