return {
  "echasnovski/mini.indentscope",
  branch = "stable",
  event = "VeryLazy",
  config = function(_, opts)
    require("mini.indentscope").setup(opts)
  end,
}
