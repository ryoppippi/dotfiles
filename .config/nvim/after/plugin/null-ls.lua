local plugin_name = "null-ls"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  local null_ls = require("null-ls")
  local diagnostics_format = "[#{c}] #{m} (#{s})"
  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  -- local code_actions = null_ls.builtins.code_actions

  null_ls.setup({
    sources = {
      -- nulls.builtins.formatting.prettier.with({
      --         extra_filetypes = {
      --             "svelte",
      --         },
      --     }),
      diagnostics.tsc.with({
        diagnostics_format = diagnostics_format,
      }),
      -- nulls.builtins.diagnostics.eslint_d.with({
      --         extra_filetypes = {
      --             "svelte",
      --         },
      --     }),
      -- python
      formatting.isort.with({
        diagnostics_format = diagnostics_format,
        prefer_local = ".venv/bin",
        extra_args = { "--profile", "black" },
      }),
      diagnostics.flake8.with({
        diagnostics_format = diagnostics_format,
        prefer_local = ".venv/bin",
        -- Ignore some errors that are always fixed by black
        extra_args = { "--extend-ignore", "E1,E2,E3,F821,E731,R504,SIM106" },
      }),
      formatting.black.with({
        diagnostics_format = diagnostics_format,
        prefer_local = ".venv/bin",
        extra_args = { "--fast", "-W", "6" },
      }),
      diagnostics.mypy.with({
        diagnostics_format = diagnostics_format,
        prefer_local = ".venv/bin",
      }),

      -- Docker
      diagnostics.hadolint,
      -- format
      -- lua
      formatting.stylua.with({
        diagnostics_format = diagnostics_format,
        condition = function(utils)
          return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
        end,
      }),
      -- others
      formatting.fish_indent,

      -- nulls.builtins.diagnostics.cspell,
    },
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
