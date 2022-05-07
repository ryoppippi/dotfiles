local utils_plug = require("utils.plugin")
local utils = require("utils")
local force_require = utils_plug.force_require

local function loading()
  local _, lspconfig = force_require("lspconfig")
  if not lspconfig then
    return
  end

  local lsp_util = lspconfig.util

  local capabilities = require("plugin.config.lsp.capabilities")()
  local on_attach = require("plugin.config.lsp.on_attach")

  local server_opts = {
    ["emmet_ls"] = {
      filetypes = { "html", "css", "svelte" },
    },
    ["tsserver"] = {
      root_dir = lsp_util.root_pattern("package.json"),
    },
    ["svelte"] = {
      root_dir = lsp_util.root_pattern("package.json"),
    },
    ["eslint"] = {
      root_dir = lsp_util.root_pattern("package.json"),
      filetypes = {
        "javascript",
        "javascriptreact",
        "javascript.jsx",
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "vue",
        "svelte",
      },
      settings = {
        format = { enable = true },
      },
    },
    ["denols"] = {
      init_options = { lint = true, unstable = true },
    },
    ["sumneko_lua"] = {
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
            path = vim.tbl_extend("force", vim.split(package.path, ";"), { "lua/?.lua", "lua/?/init.lua" }),
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
          telemetry = {
            enable = false,
          },
        },
      },
    },
    ["pyrignt"] = {
      before_init = function(_, config)
        config.settings.python.pythonPath = vim.env.VIRTUAL_ENV
            and lsp_util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
          or utils.find_cmd("python3", ".venv/bin", config.root_dir)
      end,
      settings = {
        disableOrganizeImports = true,
      },
    },
  }

  require("plugin.config.nvim-lsp-installer").config()
  local servers = require("nvim-lsp-installer").get_installed_servers()
  for _, server in ipairs(servers) do
    local opts = server_opts[server.name] or {}
    opts.on_attach = on_attach
    opts.capabilities = capabilities
    lspconfig[server.name].setup(opts)
    vim.cmd([[ do User LspAttachBuffers ]])
  end
end

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  callback = loading,
  once = true,
})
