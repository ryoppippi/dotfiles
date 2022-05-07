return function()
  local protocol = vim.lsp.protocol
  local utils_plug = require("utils.plugin")
  local capabilities = protocol.make_client_capabilities()
  local CI = capabilities.textDocument.completion.completionItem
  CI.snippetSupport = true
  CI.preselectSupport = true
  CI.insertReplaceSupport = true
  CI.labelDetailsSupport = true
  CI.deprecatedSupport = true
  CI.commitCharactersSupport = true
  CI.tagSupport = { valueSet = { 1 } }
  CI.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  capabilities.textDocument.completion.completionItem = CI

  local _, cmp_nvim_lsp = utils_plug.force_require("cmp_nvim_lsp")
  if cmp_nvim_lsp ~= nil then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end
  return capabilities
end
