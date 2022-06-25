local plugin_name = "substitute"

local function keymap()
  vim.keymap.set("n", "cx", "<cmd>lua require('substitute').operator()<cr>", {})
  vim.keymap.set("x", "cx", "<cmd>lua require('substitute').visual()<cr>", {})
  vim.keymap.set("n", "cxc", "<cmd>lua require('substitute').line()<cr>", {})
  vim.keymap.set("n", "Cx", "<cmd>lua require('substitute').eol()<cr>", {})
end

local function loading()
  keymap()
  require(plugin_name).setup({
    on_substitute = function(event)
      local y = require("utils.plugin").force_require("yanky")
      return y and y.init_ring("p", event.register, event.count, event.vmode:match("[vV�]"))
    end,
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
