return {
  "saecki/crates.nvim",
  event = { "BufRead Cargo.toml" },
  requires = { { "nvim-lua/plenary.nvim" } },
  config = function()
    require("crates").setup()
  end,
}
