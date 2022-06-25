local plugin_name = "hop"

local function loading()
  local hop = require(plugin_name)
  hop.setup()

  vim.keymap.set({ "n", "v" }, "<Leader>j", function()
    hop.hint_words()
  end, { silent = true, desc = "hop: hint_words" })
  vim.keymap.set({ "n", "v" }, "<Leader>k", function()
    hop.hint_char1()
  end, { silent = true, desc = "hop: hint_char1" })
  vim.keymap.set({ "n", "v" }, "<Leader>l", function()
    hop.hint_lines()
  end, { silent = true, desc = "hop: hint_lines" })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
