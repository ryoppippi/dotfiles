local status, onedark = pcall(require, "onedark")
if not status then
  return
end

onedark.setup({
  style = "darker",
  transparent = false,
  term_colors = true,
  ending_tildes = true,
  toggle_style_key = "<leader>ws",
  code_style = {
    comments = "italic",
    keywords = "none",
    functions = "none",
    strings = "none",
    variables = "none",
  },
  highlights = {
    rainbowcol1 = { fg = "#7645c4" },
    TSPunctBracket = { fg = "#7645c4" },
  },
  diagnostics = {
    darker = true, -- darker colors for diagnostic
    undercurl = true, -- use undercurl instead of underline for diagnostics
    background = true, -- use background color for virtual text
  },
})
vim.cmd("colorscheme onedark")
