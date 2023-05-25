return {
  "cbochs/portal.nvim",
  event = "VeryLazy",
  keys = {
    {
      "g<c-i>",
      "<cmd>Portal jumplist forward<cr>",
      desc = "portal jump backward",
    },
    {
      "g<c-o>",
      "<cmd>Portal jumplist backward<cr>",
      desc = "portal jump forward",
    },
  },
  config = {},
}
