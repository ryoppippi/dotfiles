local plugin_name = "onedark"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  require("utils.plugin").load(plugin_name)
  vim.g.onedark_config = {
    style = "cool",
    transparent = true,
    term_colors = true,
    ending_tildes = true,
    toggle_style_key = "<leader>ws",
    code_style = {
      comments = "italic",
      keywords = "italic",
      functions = "bold",
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
  }
  vim.api.nvim_exec(
    [[
    hi MatchParen ctermbg=black guibg=black
    augroup matchup_matchparen_highlight
      autocmd!
      autocmd ColorScheme onedark hi MatchParen ctermbg=black guibg=black
    augroup END
		]],
    false
  )
end

loading()
