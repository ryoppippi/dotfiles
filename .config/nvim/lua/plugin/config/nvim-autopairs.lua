local plugin_name = "nvim-autopairs"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  vim.cmd(string.format("packadd %s", plugin_name))
  require(plugin_name).setup({
    check_ts = true,
    enable_check_bracket_line = false,
    ignored_next_char = "[%w%.]",
  })
  -- local ts_conds = require("nvim-autopairs.ts-conds")
end

loading()
