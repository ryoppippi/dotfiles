return {
  dir = "",
  event = "BufReadPre",
  config = function()
    require("core.plugin").on_attach(function(client, bufnr)
      require("plugin.config.lsp.keymaps").on_attach(client, bufnr)
      require("plugin.config.lsp.diagnostic").on_attach(client, bufnr)
      -- require("plugin.config.lsp.format").on_attach(client, bufnr)

      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
      -- signature help
      -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      --   silent = true,
      --   focusable = false,
      -- })
    end)
  end,
}
