local M = {}

local gen_capabilities = function()
  local protocol = vim.lsp.protocol
  local capabilities = protocol.make_client_capabilities()

  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  if cmp_nvim_lsp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end
  return capabilities
end

M.on_attach = function(client, bufnr)
  --
end

M.capabilities = gen_capabilities()

return M
