return {
  "rgroli/other.nvim",
  cmd = { "Other", "OtherClear", "OtherSplit", "OtherVSplit" },
  opts = {
    mappings = {
      -- builtin mappings
      "livewire",
      "angular",
      "laravel",
      -- custom mapping
      {
        pattern = "src/(.*).ts$",
        target = "test/%1.test.ts",
        -- transformer = "lowercase",
      },
      {
        pattern = "test/(.*).test.ts$",
        target = "src/%1.ts",
        -- transformer = "lowercase",
      },
      {
        pattern = "lua/(.*)/(.*).lua$",
        target = "tests/%2_spec.lua",
        -- transformer = "lowercase",
      },
      {
        pattern = "tests/(.*)_spec.lua$",
        target = "lua/*/%1.lua",
        -- transformer = "lowercase",
      },
      {
        pattern = ".config/nvim/lua/rc/pluginconfig/(.*).lua$",
        target = "../.local/share/nvim/lazy/%1*/README.md",
        -- transformer = "lowercase",
      },
    },
    transformers = {
      -- defining a custom transformer
      lowercase = function(inputString)
        return inputString:lower()
      end,
    },
  },
  config = function(_, opt)
    require("other-nvim").setup(opt)
  end,
}
