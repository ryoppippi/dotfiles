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

      -- sveltekit
      {
        pattern = "/(.*)/%+(.*).server.ts$",
        target = {
          {
            target = "/%1/%+%2.svelte",
            context = "view",
          },
          {
            target = "/%1/%+%2\\(*.ts\\|*.js\\)",
            context = "script",
            transform = "add_server",
          },
        },
      },
      {
        pattern = "/(.*)/%+(.*).server.js$",
        target = {
          {
            target = "/%1/%+%2.svelte",
            context = "view",
          },
          {
            target = "/%1/%+%2\\(*.ts\\|*.js\\)",
            context = "script",
            transform = "add_server",
          },
        },
      },
      {
        pattern = "/(.*)/%+(.*).ts$",
        target = {
          {
            target = "/%1/%+%2.svelte",
            context = "view",
          },
          {
            target = "/%1/%+%2\\(*.ts\\|*.js\\)",
            context = "script",
            transform = "remove_server",
          },
        },
      },
      {
        pattern = "/(.*)/%+(.*).js$",
        target = {
          {
            target = "/%1/%+%2.svelte",
            context = "view",
          },
          {
            target = "/%1/%+%2\\(*.ts\\|*.js\\)",
            context = "script",
            transform = "remove_server",
          },
        },
      },
      {
        pattern = "/(.*)/%+(.*).svelte$",
        target = {
          {
            target = "/%1/%+%2\\(*.ts\\|*.js\\)",
            context = "script",
            transform = "remove_server",
          },
        },
      },
    },
    transformers = {
      -- remove `server` from the path
      remove_server = function(inputString)
        return inputString:gsub("server", "")
      end,
      -- add `server` to the path
      -- ex: +page.ts -> +page.server.ts
      -- ex: +page.js -> +page.server.js
      add_server = function(inputString)
        print(inputString)
        return inputString:gsub("%.(ts|js)$", ".server.%1")
      end,
    },
  },
  config = function(_, opt)
    require("other-nvim").setup(opt)
  end,
}
