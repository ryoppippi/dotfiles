local symbol_map = {}
for key, value in pairs(require("lspkind").symbol_map) do
  symbol_map[key] = value .. " "
end

require("nvim-navic").setup({
  icons = symbol_map,
  highlight = false,
  separator = " > ",
  depth_limit = 0,
  depth_limit_indicator = "..",
})
vim.g.navic_silence = true
