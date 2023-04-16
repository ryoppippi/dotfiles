return {
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
}
