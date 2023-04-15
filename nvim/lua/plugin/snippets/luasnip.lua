return {
  "L3MON4D3/LuaSnip",
  cond = (vim.g.enabled_snippet == "luasnip"),
  dependencies = require("plugin.snippets.snippets"),
  config = function()
    require("luasnip")
    require("luasnip.loaders.from_snipmate").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/my_vscode_snippets" } })
  end,
}
