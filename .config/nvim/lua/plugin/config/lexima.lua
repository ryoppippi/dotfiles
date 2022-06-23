local add_rule = vim.fn["lexima#add_rule"]
local expand = vim.fn["lexima#expand"]

vim.g.lexima_enable_basic_rules = 1
vim.g.lexima_enable_endwise_rules = 1

-- rule
local web_script_ft = { "javascript", "javaseciptreact", "typescript", "typescriptreact", "svelte" }
local web_markup_ft = { "html", "typescriptreact", "javaseciptreact", "svelte" }

-- (a>) -> (a)=>{  }
local rules = {
  {
    char = ">",
    at = [[([a-zA-Z, ]*\%#)]],
    leave = ")",
    input = " => {",
    input_after = "}",
    filetype = web_script_ft,
  },
  -- {
  --   char = ">",
  --   at = [[<\(\w\+\)\%#>]],
  --   leave = ">",
  --   input_after = "</\1>",
  --   with_submatch = 1,
  --   filetype = web_markup_ft,
  -- },
}

for _, rule in ipairs(rules) do
  add_rule(rule)
end
