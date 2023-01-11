return {
  {
    "echasnovski/mini.trailspace",
    branch = "stable",
    keys = { "TrimSpace" },
    init = function()
      vim.api.nvim_create_user_command("TrimSpace", function()
        require("mini.trailspace").trim()
      end, {})
    end,
    config = function()
      require("mini.trailspace").setup({})
    end,
  },
  {
    "echasnovski/mini.indentscope",
    branch = "stable",
    event = "VeryLazy",
    config = function()
      require("mini.indentscope").setup({})
    end,
  },
  {
    "echasnovski/mini.jump",
    branch = "stable",
    event = "BufEnter",
    config = function()
      require("mini.jump").setup({
        mappings = {
          forward = "f",
          backward = "F",
          forward_till = "",
          backward_till = "",
          repeat_jump = "",
        },
        delay = {
          highlight = 10,
        },
      })
    end,
  },
}
