local plugin_name = "lspkind"

local function loading()
  require(plugin_name).init({
    -- enables text annotations
    --
    -- default: true
    -- with_text = true

    -- default symbol map
    -- can be either 'default' (requires nerd-fonts font) or
    -- 'codicons' for codicon preset (requires vscode-codicons font)
    --
    -- default: 'default'
    preset = "codicons",

    -- override preset symbols
    --
    -- default: {}
    symbol_map = {
      Text = " ",
      Method = " ",
      Function = " ",
      Constructor = " ",
      Field = "ﰠ ",
      Variable = " ",
      Class = "ﴯ ",
      Interface = " ",
      Module = " ",
      Property = "ﰠ ",
      Unit = " ",
      Value = " ",
      Enum = " ",
      Keyword = " ",
      Snippet = " ",
      Color = " ",
      File = " ",
      Reference = " ",
      Folder = " ",
      EnumMember = " ",
      Constant = " ",
      Struct = "פּ ",
      Event = "",
      Operator = " ",
      TypeParameter = " ",
    },
  })
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = loading,
})
