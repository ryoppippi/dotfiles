return {
  "lukas-reineke/lsp-format.nvim",
  opts = { sync = true },
  enabled = true,
  init = function()
    local on_attach = require("core.plugin").on_attach
    on_attach(function(client, bufnr)
      if client.server_capabilities.documentFormattingProvider then
        require("lsp-format").on_attach(client)
        vim.cmd([[
              cabbrev wq execute "Format sync" <bar> wq
              cabbrev wqa bufdo execute "Format sync" <bar> wa <bar> q
            ]])
      end
    end)
  end,
}
