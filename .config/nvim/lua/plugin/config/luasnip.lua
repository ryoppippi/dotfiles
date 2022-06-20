local plugin_name = "luasnip"

local function loading()
  require("luasnip.loaders.from_vscode").lazy_load()
  require("luasnip.loaders.from_snipmate").lazy_load()
  require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/my_vscode_snippets" } })
end

-- require("utils.plugin").force_load_on_event(plugin_name, loading)
loading()
