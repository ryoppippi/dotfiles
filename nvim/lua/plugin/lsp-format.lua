local spec = {
  "lukas-reineke/lsp-format.nvim",
  opts = { sync = true },
  enabled = true,
  init = function()
    local on_attach = require("core.plugin").on_attach
    on_attach(function(client, _)
      local document_formatting_disable_list = { "tsserver", "svelte", "lua_ls" }
      local enableFormat = not vim.tbl_contains(document_formatting_disable_list, client.name)
        and client.server_capabilities.documentFormattingProvider
      if enableFormat then
        require("lsp-format").on_attach(client)
        vim.cmd([[
              cabbrev wq execute "Format sync" <bar> wq
              cabbrev wqa bufdo execute "Format sync" <bar> wa <bar> q
            ]])
      end
    end)
  end,
}
return spec
