local with_root_file = function(...)
  local files = { ... }
  return function(utils)
    return utils.root_has_file(files)
  end
end

local with_file = function(...)
  local files = { ... }
  return function(utils)
    return utils.has_file(files)
  end
end

local is_executable = function(cmd_name, cond)
  local u = require("null-ls.utils")
  return function()
    local ie = u.is_executable(cmd_name)
    if cond == false then
      ie = not ie
    end
    return ie
  end
end

local sources = function()
  local null_ls = require("null-ls")
  local diagnostics_format = "[#{c}] #{m} (#{s})"
  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local code_actions = null_ls.builtins.code_actions
  return {
    -- web
    formatting.prettierd.with({
      extra_filetypes = {
        "svelte",
      },
      condition = is_executable("prettierd"),
    }),

    formatting.prettier.with({
      extra_filetypes = {
        "svelte",
      },
      condition = is_executable("prettierd", false),
    }),

    diagnostics.tsc.with({
      diagnostics_format = diagnostics_format,
      condition = with_root_file("deno.json", "deno.jsonc"),
    }),

    formatting.deno_fmt.with({
      condition = with_root_file("deno.json", "deno.jsonc"),
    }),
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
    formatting.fish_indent,
    -- diagnostics.cspell,
    code_actions.gitsigns,
  }
end

local capabilities = require("plugin.config.lsp.handler").capabilities
local on_attach = require("plugin.config.lsp.handler").on_attach
require("null-ls").setup({
  on_attach = on_attach,
  capabilities = capabilities,
  sources = sources(),
})
