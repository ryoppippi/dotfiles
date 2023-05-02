-- local root_path = "lua/plugin/lsp"
local has_cmp = function()
  return require("core.plugin").has("nvim-cmp")
end

return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "folke/neoconf.nvim",
    "b0o/schemastore.nvim",
    { "hrsh7th/cmp-nvim-lsp", cond = has_cmp },
    { "hrsh7th/cmp-nvim-lsp-document-symbol", cond = has_cmp },
    { "hrsh7th/cmp-nvim-lsp-signature-help", cond = has_cmp, enabled = false },
  },
  init = function()
    require("core.plugin").on_attach(function(client, bufnr)
      require("plugin.nvim-lspconfig.keymaps").on_attach(client, bufnr)
      require("plugin.nvim-lspconfig.diagnostic").on_attach(client, bufnr)

      local lspconfig = require("lspconfig")
      local buf_name = vim.api.nvim_buf_get_name(bufnr)

      vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

      -- local node_root_dir =
      --   lspconfig.util.root_pattern("package.json", "tsconfig.json", "tsconfig.jsonc", "node_modules")
      -- local is_node_repo = node_root_dir(buf_name) ~= nil
      --
      -- local node_servers = {"angularls", "vuels", "svelte", "astro", "tsserver", "eslint",}
      -- if vim.tbl_contains(node_servers, client.name) and not is_node_repo thentbl_
      --   vim.lsp.stop_client(client.id)
      -- end
      -- if "denols" == client.name and is_node_repo then
      --   vim.lsp.stop_client(client.id)
      -- end
    end)
  end,
  opts = function()
    local o = {}
    o.opts = {}

    o.opts.capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      has_cmp() and require("cmp_nvim_lsp").default_capabilities() or {}
    )
    o.node_root_dir = {
      "package.json",
      "tsconfig.json",
      "tsconfig.jsonc",
      "node_modules",
    }

    o.html_like = {
      "astro",
      "html",
      "htmldjango",
      "css",
      "javascriptreact",
      "javascript.jsx",
      "typescriptreact",
      "typescript.tsx",
      "svelte",
      "vue",
    }

    o.disable_formatting = function(client)
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
    end

    return o
  end,
  config = function(_, opts)
    local html_like = opts.html_like
    local node_root_dir = opts.node_root_dir
    local disable_formatting = opts.disable_formatting
    opts = opts.opts

    local lspconfig = require("lspconfig")

    -- setup diagnostic signs
    local signs = { Error = "", Warn = "", Hint = "", Info = "" }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- setup server function
    local function setup(client, extra_opts)
      local local_opts = vim.tbl_deep_extend("force", {}, opts, extra_opts or {})

      local_opts.filetypes = require("core.utils").merge_arrays(
        local_opts.filetypes or client.document_config.default_config.filetypes or {},
        local_opts.extra_filetypes or {}
      )
      local_opts.extra_filetypes = nil

      client.setup(local_opts)
    end

    -- server configs

    -- html/css/js
    setup(lspconfig.emmet_ls, { extra_filetypes = html_like })
    setup(lspconfig.html, { on_attach = disable_formatting })

    setup(lspconfig.eslint, {
      extra_filetypes = { "svelte" },
      root_dir = lspconfig.util.root_pattern(node_root_dir),
      on_attach = disable_formatting,
    })

    setup(lspconfig.denols, {
      single_file_support = false,
      root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json"),
      init_options = {
        lint = true,
        unstable = true,
        suggest = {
          imports = {
            hosts = {
              ["https://deno.land"] = true,
              ["https://cdn.nest.land"] = true,
              ["https://crux.land"] = true,
              ["https://esm.sh"] = true,
            },
          },
        },
      },
    })

    -- web DSL
    setup(lspconfig.svelte, { on_attach = disable_formatting })
    setup(lspconfig.astro, { on_attach = disable_formatting })
    setup(lspconfig.angularls)
    setup(lspconfig.vuels)
    setup(lspconfig.prismals)

    -- lua
    setup(lspconfig.lua_ls, {
      on_attach = disable_formatting,
      flags = {
        debounce_text_changes = 150,
      },
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
        },
      },
    })

    -- json
    setup(lspconfig.jsonls, {
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
          format = { enable = true },
        },
      },
    })

    -- yaml
    setup(lspconfig.yamlls, {
      settings = {
        yaml = {
          schemas = require("schemastore").yaml.schemas(),
          validate = true,
          format = { enable = true },
        },
      },
    })

    -- swift
    setup(lspconfig.sourcekit)

    -- python
    setup(lspconfig.pyright, {
      before_init = function(_, config)
        config.settings.python.pythonPath = vim.env.VIRTUAL_ENV
            and lspconfig.util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
          or require("core.utils").find_cmd("python3", ".venv/bin", config.root_dir)
      end,
    })

    -- zigls
    local zls_path = os.getenv("HOME") .. "/zls/zig-out/bin/zls"
    local zls = lspconfig.zls
    setup(zls, {
      cmd = tb(vim.fn.executable(zls_path)) and { zls_path } or zls.document_config.default_config.cmd,
    })
  end,
}
