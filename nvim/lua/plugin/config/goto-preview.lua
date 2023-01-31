return {
  "rmagatti/goto-preview",
  enabled = false,
  config = function()
    require("goto-preview").setup({
      default_mappings = true,
      opacity = 7,
      focus_on_open = false,
      dismiss_on_move = true,
    })
  end,
}
