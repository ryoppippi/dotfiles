local function loading()
  local trevj = require("trevj")
  trevj.setup()
  vim.keymap.set("n", "<leader>j", function()
    trevj.format_at_cursor()
  end)
end

require("utils.plugin").force_load_on_event("nvim-trevJ", loading)
