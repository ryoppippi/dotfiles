return {
  {
    "jose-elias-alvarez/typescript.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local opts = require("lazy.core.config").plugins["nvim-lspconfig"].opts()

      require("typescript").setup({
        server = {
          on_attach = opts.disable_formatting,
          capabilities = opts.capabilities,
          root_dir = lspconfig.util.root_pattern(opts.node_root_dir),
        },
        debug = false,
        disable_commands = false,
      })
      return opts
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      table.insert(opts.sources, require("typescript.extensions.null-ls.code-actions"))
    end,
  },
}
