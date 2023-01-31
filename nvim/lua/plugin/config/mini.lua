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
    config = function(_, opts)
      require("mini.trailspace").setup(opts)
    end,
  },
  {
    "echasnovski/mini.indentscope",
    branch = "stable",
    event = "VeryLazy",
    config = function(_, opts)
      require("mini.indentscope").setup(opts)
    end,
  },
  {
    "echasnovski/mini.jump",
    branch = "stable",
    event = "BufEnter",
    opts = {
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
    },
    config = function(_, opts)
      require("mini.jump").setup(opts)
    end,
  },
}
