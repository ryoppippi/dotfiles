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
  {
    "echasnovski/mini.surround",
    version = "*",
    event = "VeryLazy",
    enabled = true,
    opts = {
      mappings = {
        add = "sa", -- Add surrounding in Normal and Visual modes
        delete = "sd", -- Delete surrounding
        find = "sf", -- Find surrounding (to the right)
        find_left = "sF", -- Find surrounding (to the left)
        highlight = "", -- Highlight surrounding
        replace = "sr", -- Replace surrounding
        update_n_lines = "sn", -- Update `n_lines`
        suffix_last = "l", -- Suffix to search with "prev" method
        suffix_next = "n", -- Suffix to search with "next" method
      },
    },
    config = function(_, opts)
      -- use gz mappings instead of s to prevent conflict with leap
      require("mini.surround").setup(opts)
    end,
  },
}
