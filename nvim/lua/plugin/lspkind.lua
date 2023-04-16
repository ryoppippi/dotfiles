return {
  "onsails/lspkind.nvim",
  config = function(_, opts)
    require("lspkind").init(opts)
  end,
  opts = {
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
      Copilot = " ",
    },
  },
}
