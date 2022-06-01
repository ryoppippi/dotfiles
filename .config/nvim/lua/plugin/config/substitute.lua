local plugin_name = "substitute"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function keymap()
  vim.keymap.set("n", "cx", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
  vim.keymap.set("x", "cx", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })
  vim.keymap.set("n", "cxc", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
  vim.keymap.set("n", "Cx", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
end

local function loading()
  keymap()
  require(plugin_name).setup({
    on_substitute = function(event)
      require("yanky").init_ring("p", event.register, event.count, event.vmode:match("[vV�]"))
    end,
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
