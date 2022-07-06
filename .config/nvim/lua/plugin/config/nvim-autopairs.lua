local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local ts_conds = require("nvim-autopairs.ts-conds")
local conds = require("nvim-autopairs.conds")
local add_rules = npairs.add_rules

npairs.setup({
  check_ts = true,
  enable_check_bracket_line = true,
  ignored_next_char = "[%w%.]",
})

-- rules
-- add_rules({
--   Rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript" })
--     :use_regex(true)
--     :set_end_pair_length(2),
-- })
