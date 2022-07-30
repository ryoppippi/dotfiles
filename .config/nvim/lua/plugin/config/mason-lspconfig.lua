local force_require = require("utils.plugin").force_require
local utils = require("utils")

require("plugin.config.mason")
local mason_lspconfig = force_require("mason-lspconfig")
if not mason_lspconfig then
  vim.api.nvim_echo("lspconfig installer not found", true, {})
  return
end

local lspconfig = force_require("lspconfig")
if not lspconfig then
  vim.api.nvim_echo("lspconfig not found", true, {})
  return
end

mason_lspconfig.setup({
  ensure_installed = {
    -- LSP
    "emmet_ls",
    "tailwindcss",
    "stylelint",
    "eslint",
    "denols",
    "svelte",
    "vue-language-server",
    "angularls",
    "tsserver",
    "prismals",
    "pyright",
    "r_language_server",
    "rust_analyzer",
    "zls",
    "sumneko_lua",
    "golps",
    "sqls",
    "jsonls",
    "yamlls",
    "vint",
  },
})

local lsp_util = lspconfig.util
local handler = require("plugin.config.lsp.handler")
local capabilities = handler.capabilities
local on_attach = handler.on_attach

mason_lspconfig.setup_handlers({
  function(server)
    local opts = { capabilities = capabilities, on_attach = on_attach }

    if "emmet_ls" == server then
      opts.extra_filetypes = {
        "javascriptreact",
        "javascript.jsx",
        "typescriptreact",
        "typescript.tsx",
        "svelte",
        "vue",
      }
    elseif "angularls" == server then
      opts.root_dir = lsp_util.root_pattern("angular.json")
    elseif "tailwindcss" == server then
      opts.root_dir = lsp_util.root_pattern("tailwind.config.js", "tailwind.config.cjs")
    elseif "svelte" == server then
      opts.root_dir = lsp_util.root_pattern("svelte.config.js", "svelte.config.cjs")
    elseif "eslint" == server then
      opts.extra_filetypes = { "svelte" }
      opts.settings = {
        format = { enable = true },
      }
    elseif "denols" == server then
      opts.root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json")
      opts.init_options = { lint = true, unstable = true }
    elseif "tsserver" == server then
      opts.root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "tsconfig.jsonc")
      local ts = force_require("typescript")
      if ts then
        ts.setup({
          server = opts,
          disable_commands = false,
        })
        goto continue
      end
    elseif "pyright" == server then
      opts.before_init = function(_, config)
        config.settings.python.pythonPath = vim.env.VIRTUAL_ENV
            and lsp_util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
          or utils.find_cmd("python3", ".venv/bin", config.root_dir)
      end
      opts.settings = {
        disableOrganizeImports = true,
      }
    elseif "rust_analyzer" == server then
      local rust_tools = force_require("rust-tools")
      if rust_tools then
        rust_tools.setup({ server = opts, on_initialized = on_attach })
        goto continue
      end
    elseif "sumneko_lua" == server then
      local lua_dev = force_require("lua-dev")
      if lua_dev then
        local luadev = lua_dev.setup({
          library = {
            vimruntime = true,
            types = true,
            plugins = true,
            -- plugins = { "nvim-treesitter", "plenary.nvim" },
          },
          runtime_path = false,
          lspconfig = {
            on_attach = on_attach,
            flags = {
              debounce_text_changes = 150,
            },
            capabilities = capabilities,
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
          },
        })
        lspconfig[server].setup(luadev)
        goto continue
      else
        opts.settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        }
      end
    elseif "golps" == server then
      local go = force_require("go")
      if go then
        go.setup()
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = "*.go",
          callback = function()
            require("go.format").gofmt()
          end,
        })
      end
      goto continue
    elseif "jsonls" == server then
      local sc = force_require("schemastore")
      if sc then
        opts.settings = {
          json = {
            schemas = sc.json.schemas(),
          },
        }
      end
    end

    if opts.extra_filetypes then
      local new_filetypes = opts.filetypes or lspconfig[server].document_config.default_config.filetypes or {}
      for _, ft in ipairs(opts.extra_filetypes) do
        table.insert(new_filetypes, ft)
      end
      opts.filetypes = new_filetypes
      opts.extra_filetypes = nil
    end

    lspconfig[server].setup(opts)
    ::continue::
    vim.cmd([[ do User LspAttachBuffers ]])
  end,
})
