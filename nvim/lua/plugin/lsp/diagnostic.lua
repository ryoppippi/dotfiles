local M = {}

 function M.diagnostic_formatter(diagnostic)
  return string.format("[%s] %s (%s)", diagnostic.message, diagnostic.source, diagnostic.code)
end

function M.on_attach(client, bufnr)
  vim.diagnostic.config({
    underline = true,
    signs = true,
    update_in_insert = false,
    severity_sort = true,
    virtual_text = { format = M.diagnostic_formatter },
    float = { sformat = M.diagnostic_formatter },
  })
end

return M
