local function loading()
  local add_rule = vim.fn["lexima#add_rule"]
  local expand = vim.fn["lexima#expand"]

  vim.g.lexima_enable_basic_rules = 1
  vim.g.lexima_enable_endwise_rules = 0

  -- rule
  local web_script_ft = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
    "vue",
    "svelte",
  }
  local web_markup_ft = { "html", "typescriptreact", "javaseciptreact", "svelte" }

  local rules = {
    -- (a>) -> (a)=>{  }
    {
      char = ">",
      at = [[([a-zA-Z, ]*\%#)]],
      leave = ")",
      input = " => {",
      input_after = "}",
      filetype = web_script_ft,
    },
  }

  for _, rule in ipairs(rules) do
    add_rule(rule)
  end
end

require("utils.plugin").force_load_on_event("lexima", loading)
