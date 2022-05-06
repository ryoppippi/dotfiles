local plugin_name = "null-ls"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local on_attach = function(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      -- on 0.8, you should use vim.lsp.buf.format instead
      callback = vim.lsp.buf.formatting_seq_sync,
    })
  end
  local _, ill_client = require("utils.plugin").force_require("illuminate")
  if ill_client ~= nil then
    ill_client.on_attach(client)
  end
end

local sources = function()
  local null_ls = require(plugin_name)
  local diagnostics_format = "[#{c}] #{m} (#{s})"
  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  -- local code_actions = null_ls.builtins.code_actions
  return {
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

    formatting.deno_fmt,
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
  }
end

local function loading()
  require(plugin_name).setup({
    on_attach = on_attach,
    sources = sources(),
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
