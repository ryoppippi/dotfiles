local plugin_name = "onedark"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  require("utils.plugin").load(plugin_name)
  require(plugin_name).setup({
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
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
