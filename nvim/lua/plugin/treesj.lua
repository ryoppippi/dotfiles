return {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  keys = {
    {
      "<leader>j",
      function()
        require("treesj").toggle({ split = { recursive = true } })
      end,
    },
  },
  opts = {
    use_default_keymaps = false,
  },
}
