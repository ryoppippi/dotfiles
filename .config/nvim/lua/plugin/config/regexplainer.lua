local function loading()
  require("regexplainer").setup({
    display = "popup",

    mappings = {
      toggle = "gR",
      -- examples, not defaults:
      -- show = 'gS',
      -- hide = 'gH',
      -- show_split = 'gP',
      -- show_popup = 'gU',
    },
  })
end

require("utils.plugin").force_load_on_event("regexplainer", loading)
