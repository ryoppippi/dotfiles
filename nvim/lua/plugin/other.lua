return {
  "rgroli/other.nvim",
  lazy = false,
  cmd = { "Other", "OtherClear", "OtherSplit", "OtherVSplit" },
  opts = {
    mappings = {
      -- builtin mappings
      "livewire",
      "angular",
      "laravel",
      -- custom mapping
      {
        pattern = "/(.*)/(.*)/(.*).ts$",
        target = {
          {
            target = "/%1/%2/%3.svelte",
            context = "script",
          },
        },
      },
      {
        pattern = "/(.*)/(.*)/(.*).js$",
        target = {
          {
            target = "/%1/%2/%3.svelte",
            context = "script",
          },
        },
      },

      {
        pattern = "/(.*)/(.*)/(.*).svelte$",
        target = {
          {
            target = "/%1/%2/%3\\(*.ts\\|*.js\\)",
            context = "view",
          },
        },
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
