vim.g.enabled_snippet = vim.g.enabled_snippet or "luasnip"

if vim.g.enabled_snippet == "luasnip" then
  return require("plugin.snippets.luasnip")
elseif vim.g.enabled_snippet == "vsnip" then
  return require("plugin.snippets.vsnip")
end
