return {
  "aznhe21/actions-preview.nvim",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
  },
  keys = {
    {
      "gA",
      function()
        require("actions-preview").code_actions()
      end,
      mode = { "n", "v" },
    },
  },
  config = function()
    require("actions-preview").setup({
      telescope = require("telescope.themes").get_dropdown({ winblend = 10 }),
    })
  end,
}
