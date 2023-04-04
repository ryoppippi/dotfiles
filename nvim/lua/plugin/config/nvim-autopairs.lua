return {
  "windwp/nvim-autopairs",
  event = { "InsertEnter" },
  enabled = true,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = {
    check_ts = true,
    enable_check_bracket_line = true,
    ignored_next_char = "[%w%.]",
  },
}
