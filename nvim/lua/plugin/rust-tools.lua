return {
  "simrat39/rust-tools.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
  },
  ft = { "rust" },
  config = function()
    local opts = require("lazy.core.config").plugins["nvim-lspconfig"].opts()
    require("rust-tools").setup({
      server = {
        capabilities = opts.capabilities,
      },
    })
    return opts
  end,
}
