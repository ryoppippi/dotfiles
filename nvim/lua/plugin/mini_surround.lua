return {
  "echasnovski/mini.surround",
  version = "*",
  event = "VeryLazy",
  enabled = false,
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
}
