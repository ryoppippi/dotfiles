local plugin_name = "hop"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  local hop = require(plugin_name)
  hop.setup()

  local opt = { silent = true, noremap = true }
  vim.keymap.set({ "n", "v" }, "<Leader>j", function()
    hop.hint_words()
  end, opt)
  vim.keymap.set({ "n", "v" }, "<Leader>k", function()
    hop.hint_char1()
  end, opt)
  vim.keymap.set({ "n", "v" }, "<Leader>l", function()
    hop.hint_lines()
  end, opt)
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
