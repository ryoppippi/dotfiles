return {
  "windwp/nvim-autopairs",
  -- event = { "InsertEnter" },
  lazy = true,
  enabled = false,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = {
    check_ts = true,
    enable_check_bracket_line = true,
    ignored_next_char = "[%w%.]",
  },
}
