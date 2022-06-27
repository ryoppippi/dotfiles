require("pretty-fold").setup({
  fill_char = "┄",
  sections = {
    left = {
      "content",
    },
    right = {
      " ",
      "number_of_folded_lines",
      ": ",
      "percentage",
      " ",
      function(config)
        return config.fill_char:rep(3)
      end,
    },
  },

  remove_fold_markers = true,

  -- Keep the indentation of the content of the fold string.
  keep_indentation = true,

  -- Possible values:
  -- "delete" : Delete all comment signs from the fold string.
  -- "spaces" : Replace all comment signs with equal number of spaces.
  -- false    : Do nothing with comment signs.
  comment_signs = "spaces",

  -- List of patterns that will be removed from content foldtext section.
  stop_words = {
    "@brief%s*", -- (for cpp) Remove '@brief' and all spaces after.
  },

  add_close_pattern = true,
  matchup_patterns = {
    { "{", "}" },
    { "%(", ")" }, -- % to escape lua pattern char
    { "%[", "]" }, -- % to escape lua pattern char
    { "if%s", "end" },
    { "do%s", "end" },
    { "for%s", "end" },
  },
})
require("pretty-fold.preview").setup_keybinding("h")
