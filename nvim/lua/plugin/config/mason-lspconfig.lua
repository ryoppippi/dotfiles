return {
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "folke/neoconf.nvim",
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
  },
  config = function()
    require("mason")
    local mason_lspconfig = require("mason-lspconfig")

    local lspconfig = require("lspconfig")
    local lsp_util = lspconfig.util
    local utils = require("utils")

    mason_lspconfig.setup({
      ensure_installed = {
        "emmet_ls",
        "tailwindcss",
        "stylelint_lsp",
        "tsserver",
        "eslint",
        "denols",
        "svelte",
        "angularls",
        "vuels",
        "astro",
        "prismals",
        "pyright",
        "r_language_server",
        "rust_analyzer",
        -- "zls",
        "lua_ls",
        "gopls",
        "sqls",
        "jsonls",
        "yamlls",
      },
    })

    local handler = require("plugin.config.lsp.handler")
    local capabilities = handler.capabilities
    local on_attach = handler.on_attach

    require("neoconf")

    mason_lspconfig.setup_handlers({
      function(server_name)
        local opts = {
          capabilities = capabilities,
          on_attach = on_attach,
        }

        if "emmet_ls" == server_name then
          opts.extra_filetypes = {
            "javascriptreact",
            "javascript.jsx",
            "typescriptreact",
            "typescript.tsx",
            "svelte",
            "vue",
          }
        elseif "angularls" == server_name then
          opts.root_dir = lsp_util.root_pattern("angular.json")
          -- elseif "tailwindcss" == server_name then
          --   opts.root_dir = lsp_util.root_pattern("tailwind.config.js", "tailwind.config.cjs")
          -- elseif "svelte" == server_name then
          --   opts.root_dir = lsp_util.root_pattern("svelte.config.js", "svelte.config.cjs")
        elseif "eslint" == server_name then
          opts.extra_filetypes = { "svelte" }
          opts.root_dir = lsp_util.root_pattern("package.json", "tsconfig.json", "tsconfig.jsonc", "node_modules")
          opts.settings = {
            format = { enable = true },
          }
        elseif "denols" == server_name then
          opts.single_file_support = false
          opts.root_dir = lsp_util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json")
          opts.init_options = {
            lint = true,
            unstable = true,
            suggest = {
              imports = {
                hosts = {
                  ["https://deno.land"] = true,
                  ["https://cdn.nest.land"] = true,
                  ["https://crux.land"] = true,
                },
              },
            },
          }
        elseif "tsserver" == server_name then
          opts.root_dir = lsp_util.root_pattern("package.json", "tsconfig.json", "tsconfig.jsonc", "node_modules")
          local ts = require("typescript")
          ts.setup({
            server = opts,
            disable_commands = false,
          })
          goto continue
        elseif "pyright" == server_name then
          opts.before_init = function(_, config)
            config.settings.python.pythonPath = vim.env.VIRTUAL_ENV
                and lsp_util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
              or utils.find_cmd("python3", ".venv/bin", config.root_dir)
          end
          opts.settings = {
            disableOrganizeImports = true,
          }
        elseif "rust_analyzer" == server_name then
          local rust_tools = require("rust-tools")
          rust_tools.setup({ server = opts, on_initialized = on_attach })
          goto continue
        elseif "lua_ls" == server_name then
          opts.flags = {
            debounce_text_changes = 150,
          }
          opts.settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
            },
          }
        elseif "golps" == server_name then
          local go = require("go")
          go.setup()
          vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*.go",
            callback = function()
              require("go.format").gofmt()
            end,
          })
          goto continue
        elseif "jsonls" == server_name then
          local sc = require("schemastore")
          opts.settings = {
            json = {
              schemas = sc.json.schemas(),
            },
          }
        elseif "zigls" == server_name then
          local zls_path = os.getenv("HOME") .. "/zls/zig-out/bin/zls"
          if os.execute(zls_path .. " " .. "--version") == 0 then
            opts.cmd = { zls_path }
          end
        end

        if opts.extra_filetypes then
          local new_filetypes = opts.filetypes or lspconfig[server_name].document_config.default_config.filetypes or {}
          for _, ft in ipairs(opts.extra_filetypes) do
            table.insert(new_filetypes, ft)
          end
          opts.filetypes = new_filetypes
          opts.extra_filetypes = nil
        end

        lspconfig[server_name].setup(opts)
        ::continue::
        vim.cmd([[ do User LspAttachBuffers ]])
      end,
    })

    lspconfig.zls.setup({
      capabilities = capabilities,
      on_attach = on_attach,
      cmd = { os.getenv("HOME") .. "/zls/zig-out/bin/zls" },
    })
  end,
}
