local plugin_name = "open-browser.vim"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  vim.keymap.set({ "n", "v" }, "<Leader>b", "<Plug>(openbrowser-smart-search)")
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
