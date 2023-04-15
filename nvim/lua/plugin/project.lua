return {
  "ahmedkhalf/project.nvim",
  event = "BufWinEnter",
  config = function(_, opts)
    require("project_nvim").setup(opts)
  end,
}
