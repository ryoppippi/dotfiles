local plugin_name = "nvim-autopairs"

local function loading()
  require(plugin_name).setup({
    check_ts = true,
    enable_check_bracket_line = true,
    ignored_next_char = "[%w%.]",
  })
  -- local ts_conds = require("nvim-autopairs.ts-conds")
end

loading()
