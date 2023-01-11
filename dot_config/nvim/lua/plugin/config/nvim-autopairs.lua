return {
  "windwp/nvim-autopairs",
  -- event = { "InsertEnter" },
  lazy = true,
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  config = function()
    local autopairs = require("nvim-autopairs")

    autopairs.setup({
      check_ts = true,
      enable_check_bracket_line = true,
      ignored_next_char = "[%w%.]",
    })

    -- local Rule = require("nvim-autopairs.rule")
    -- local ts_conds = require("nvim-autopairs.ts-conds")
    -- local conds = require("nvim-autopairs.conds")
    -- local add_rules = autopairs.add_rules
    -- rules
    -- add_rules({
    --   Rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript" })
    --     :use_regex(true)
    --     :set_end_pair_length(2),
    -- })
  end,
}
