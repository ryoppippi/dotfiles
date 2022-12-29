return {
  "cbochs/portal.nvim",
  keys = {
    {
      "g<c-i>",
      function()
        require("portal").jump_backward()
      end,
      {},
    },
    {
      "g<c-o>",
      function()
        require("portal").jump_forward()
      end,
      {},
    },
  },
  config = function()
    require("portal").setup({})
  end,
}
