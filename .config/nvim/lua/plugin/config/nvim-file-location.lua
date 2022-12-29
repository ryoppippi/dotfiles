return {
  "diegoulloao/nvim-file-location",
  keys = { "<leader>L" },
  config = function()
    require("nvim-file-location").setup({
      keymap = "<leader>L",
      mode = "workdir", -- options: workdir | absolute
      add_line = true,
      add_column = false,
    })
  end,
}
