local status, autopairs = pcall(require, "nvim-autopairs")
if (not status) then return end

autopairs.setup({
  check_ts = true,
  enable_check_bracket_line = false,  
  ignored_next_char = "[%w%.]"
})

local ts_conds = require('nvim-autopairs.ts-conds')

