return {
  "jose-elias-alvarez/null-ls.nvim",
  event = { "BufReadPost" },
  dependencies = {
    "jay-babu/mason-null-ls.nvim",
  },
  opts = function(_, opts)
    local null_ls = require("null-ls")
    local diagnostics_format = "[#{c}] #{m} (#{s})"
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    local with_root_file = function(...)
      local files = { ... }
      return function(utils)
        return utils.root_has_file(files)
      end
    end

    -- local with_file = function(...)
    --   local files = { ... }
    --   return function(utils)
    --     return utils.has_file(files)
    --   end
    -- end

    return vim.tbl_deep_extend("force", opts, {
      sources = {
        -- web

        formatting.prettier.with({
          extra_filetypes = { "svelte" },
        }),

        -- formatting.prettierd.with({
        --   extra_filetypes = { "svelte" },
        --   -- extra_args = { "--write" },
        --   -- generator_opts = { to_stdin = false },
        -- }),

        diagnostics.tsc.with({
          diagnostics_format = diagnostics_format,
          condition = with_root_file("deno.json", "deno.jsonc"),
        }),

        formatting.deno_fmt.with({
          condition = with_root_file("deno.json", "deno.jsonc"),
        }),

        -- python
        formatting.ruff.with({
          diagnostics_format = diagnostics_format,
          prefer_local = ".venv/bin",
          -- extra_args = { "--fast", "-W", "6" },
        }),

        diagnostics.mypy.with({
          diagnostics_format = diagnostics_format,
          prefer_local = ".venv/bin",
        }),

        -- Docker
        diagnostics.hadolint.with({
          diagnostics_format = diagnostics_format,
        }),
        -- format
        -- lua
        formatting.stylua.with({
          diagnostics_format = diagnostics_format,
          condition = with_root_file({ "stylua.toml", ".stylua.toml" }),
        }),

        -- others
        diagnostics.fish,
        formatting.fish_indent,
        -- diagnostics.cspell,
      },
    })
  end,
}
