local utils_plug = require("utils.plugin")
local force_require = utils_plug.force_require

local function loading()
  local status, lspconfig = force_require("lspconfig")
  if not status or not lspconfig then
    return
  end

  local handler = require("plugin.config.lsp.handler")
  local capabilities = handler.capabilities
  local on_attach = handler.on_attach
  local server_opts = handler.server_opts

  require("plugin.config.nvim-lsp-installer").config()
  local servers = require("nvim-lsp-installer").get_installed_servers()
  for _, server in ipairs(servers) do
    local opts = server_opts(server.name, on_attach, capabilities)
    lspconfig[server.name].setup(opts)
    vim.cmd([[ do User LspAttachBuffers ]])
  end
end

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  callback = loading,
  once = true,
})
