return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre" },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    local signs = { Error = "", Warn = "", Hint = "", Info = "" }
    -- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
  end,
}
