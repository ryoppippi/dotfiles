return {
  "AckslD/nvim-trevJ.lua",
  enabled = false,
  keys = {
    {
      "<leader>j",
      function()
        require("trevj").format_at_cursor()
      end,
    },
  },
  config = true,
}
