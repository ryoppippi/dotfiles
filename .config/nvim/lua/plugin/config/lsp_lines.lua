return {
  url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  name = "lsp_lines",
  dependencies = { "neovim/nvim-lspconfig" },
  event = "VeryLazy",
  keys = {
    {
      "<Leader>l",
      function()
        local state = require("lsp_lines").toggle()
        vim.diagnostic.config({
          virtual_text = not state,
        })
      end,
      mode = { "n", "v" },
      desc = "Toggle lsp_lines",
    },
  },
  config = function()
    require("lsp_lines").setup()
    vim.diagnostic.config({
      virtual_text = false,
    })
  end,
}
