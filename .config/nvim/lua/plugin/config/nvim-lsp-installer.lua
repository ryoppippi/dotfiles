local function loading()
  local force_require = require("utils.plugin").force_require
  local utils = require("utils")
  local utils_plug = require("utils.plugin")

  local status, lspinstaller = force_require("nvim-lsp-installer")
  if not status then
    return
  end

  local lsp_status, lspconfig = force_require("lspconfig")
  if not lsp_status or not lspconfig then
    return
  end
  local lsp_util = lspconfig.util

  lspinstaller.setup({
    ui = {
      icons = {
        server_installed = "✓",
        server_pending = "➜",
        server_uninstalled = "✗",
      },
    },
  })

  local handler = require("plugin.config.lsp.handler")
  local capabilities = handler.capabilities
  local on_attach = handler.on_attach

  for _, server in ipairs(lspinstaller.get_installed_servers()) do
    local opts = { capabilities = capabilities, on_attach = on_attach }
    local name = server.name

    local web_filetypes= {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
        "svelte",
      }

    if "emmet_ls" == name then
      opts.filetypes =web_filetypes
    elseif "angularls" == name then
      opts.root_dir = lsp_util.root_pattern("angular.json")
    elseif "tailwindcss" == name then
      opts.root_dir = lsp_util.root_pattern("tailwind.config.js", "tailwind.config.cjs")
    elseif "svelte" == name then
      opts.root_dir = lsp_util.root_pattern("svelte.config.js", "svelte.config.cjs")
    elseif "eslint" == name then
      opts.root_dir = lsp_util.root_pattern(".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json")
      opts.filetypes = web_filetypes
      opts.settings = {
        format = { enable = true },
      }
    elseif "tsserver" == name then
      local ts_status, ts = force_require("typescript")
      if ts_status and ts ~= nil then
        ts.setup({
          server = opts,
          disable_commands = false,
        })
        goto continue
      end
    elseif "denols" == name then
      opts.root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc")
      opts.init_options = { lint = true, unstable = true }
    elseif "pyright" == name then
      opts.before_init = function(_, config)
        config.settings.python.pythonPath = vim.env.VIRTUAL_ENV
            and lsp_util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
          or utils.find_cmd("python3", ".venv/bin", config.root_dir)
      end
      opts.settings = {
        disableOrganizeImports = true,
      }
    elseif "rust_analyzer" == name then
      local status_rust_tools, rust_tools = force_require("rust-tools")
      if status_rust_tools then
        rust_tools.setup({ server = opts, on_initialized = on_attach })
        goto continue
      end
    elseif "sumneko_lua" == name then
      local status_lua_dev, lua_dev = force_require("lua-dev")
      if status_lua_dev then
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
        lspconfig[server.name].setup(luadev)
        goto continue
      end
    elseif "golps" == name then
      local status_go, go = force_require("go")
      if status_go then
        go.setup()
        vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').gofmt() ]], false)
      end
    elseif "jsonls" == name then
      local sc_status, sc = force_require("schemastore")
      if sc_status then
        opts.settings = {
          json = {
            schemas = sc.json.schemas(),
          },
        }
      end
    end

    lspconfig[name].setup(opts)
    ::continue::
    vim.cmd([[ do User LspAttachBuffers ]])
  end
end

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  callback = loading,
  once = true,
})
