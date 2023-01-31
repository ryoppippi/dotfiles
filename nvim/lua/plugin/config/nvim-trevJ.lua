return {
  "AckslD/nvim-trevJ.lua",
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
