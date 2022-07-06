local force_require = require("utils.plugin").force_require
local utils = require("utils")

local lspinstaller = force_require("nvim-lsp-installer")
if not lspinstaller then
  vim.api.nvim_echo("nvim-lsp-installer not found", true, {})
  return
end

local lspconfig = force_require("lspconfig")
if not lspconfig then
  vim.api.nvim_echo("lspconfig not found", true, {})
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

  if "emmet_ls" == name then
    opts.extra_filetypes = {
      "javascriptreact",
      "javascript.jsx",
      "typescriptreact",
      "typescript.tsx",
      "svelte",
      "vue",
    }
  elseif "angularls" == name then
    opts.root_dir = lsp_util.root_pattern("angular.json")
  elseif "tailwindcss" == name then
    opts.root_dir = lsp_util.root_pattern("tailwind.config.js", "tailwind.config.cjs")
  elseif "svelte" == name then
    opts.root_dir = lsp_util.root_pattern("svelte.config.js", "svelte.config.cjs")
  elseif "eslint" == name then
    opts.extra_filetypes = { "svelte" }
    opts.settings = {
      format = { enable = true },
    }
  elseif "denols" == name then
    opts.root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deps.ts", "import_map.json")
    opts.init_options = { lint = true, unstable = true }
  elseif "tsserver" == name then
    opts.root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "tsconfig.jsonc")
    local ts = force_require("typescript")
    if ts then
      ts.setup({
        server = opts,
        disable_commands = false,
      })
      goto continue
    end
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
    local rust_tools = force_require("rust-tools")
    if rust_tools then
      rust_tools.setup({ server = opts, on_initialized = on_attach })
      goto continue
    end
  elseif "sumneko_lua" == name then
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
      lspconfig[server.name].setup(luadev)
      goto continue
    end
  elseif "golps" == name then
    local go = force_require("go")
    if go then
      go.setup()
      vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').gofmt() ]], false)
    end
    goto continue
  elseif "jsonls" == name then
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
    local new_filetypes = opts.filetypes or lspconfig[name].document_config.default_config.filetypes or {}
    for _, ft in ipairs(opts.extra_filetypes) do
      table.insert(new_filetypes, ft)
    end
    opts.filetypes = new_filetypes
    opts.extra_filetypes = nil
  end

  lspconfig[name].setup(opts)
  ::continue::
  vim.cmd([[ do User LspAttachBuffers ]])
end
