return {
  "cbochs/portal.nvim",
  keys = {
    {
      "g<c-i>",
      function()
        require("portal").jump_backward()
      end,
       desc = "portal jump backward" ,
    },
    {
      "g<c-o>",
      function()
        require("portal").jump_forward()
      end,
       desc = "portal jump forward" ,
    },
  },
  config = function()
    require("portal").setup({})
  end,
}
