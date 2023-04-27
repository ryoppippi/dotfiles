local function diagnostic_formatter(diagnostic)
  return string.format("[%s] %s (%s)", diagnostic.message, diagnostic.source, diagnostic.code)
end

return {
  on_attach = function(client, bufnr)
    vim.diagnostic.config({
      underline = true,
      signs = true,
      update_in_insert = false,
      severity_sort = true,
      virtual_text = { format = diagnostic_formatter },
      float = { sformat = diagnostic_formatter },
    })
  end,
}
