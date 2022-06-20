local plugin_name = "modesearch"

local function loading()
  vim.keymap.set("n", "g/", "<Plug>(modesearch-slash)")
  vim.keymap.set("n", "g?", "<Plug>(modesearch-question)")
  vim.keymap.set("c", "<c-x>", "<Plug>(modesearch-toggle-mode)")
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
