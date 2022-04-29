local util_plug = require("utils.plugin")
local force_require = util_plug.force_require

local _, lsp_installer = force_require("nvim-lsp-installer")
local _, lspconfig = force_require("lspconfig")
if not lsp_installer or not lspconfig then
  return
end

local lsp_util = lspconfig.util

local function generate_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local completionItem = capabilities.textDocument.completion.completionItem
  completionItem.snippetSupport = true
  completionItem.preselectSupport = true
  completionItem.insertReplaceSupport = true
  completionItem.labelDetailsSupport = true
  completionItem.deprecatedSupport = true
  completionItem.commitCharactersSupport = true
  completionItem.tagSupport = { valueSet = { 1 } }
  completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  capabilities.textDocument.completion.completionItem = completionItem

  local _, cmp_nvim_lsp = require("utils.plugin").force_require("cmp_nvim_lsp")
  if cmp_nvim_lsp ~= nil then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end
  return capabilities
end

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

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
          path = runtime_path,
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
      local p
      if vim.env.VIRTUAL_ENV then
        p = lsp_util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
      else
        p = utils.find_cmd("python3", ".venv/bin", config.root_dir)
      end
      config.settings.python.pythonPath = p
    end,
    settings = {
      disableOrganizeImports = true,
    },
  },
}

local on_attach = function(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  -- vim.keymap.set('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- vim.keymap.set('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  --vim.keymap.set('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.keymap.set("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  vim.keymap.set("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  vim.keymap.set("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  -- vim.keymap.set('n', '<space>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- vim.keymap.set('n', '<leader>r', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  -- vim.keymap.set("n", "-", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  -- vim.keymap.set("n", "_", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  -- vim.keymap.set("n", "gl", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  vim.keymap.set("n", "<leader>zz", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  vim.keymap.set("n", "<leader>zx", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)

  -- formatting
  local df = {
    ["tsserver"] = false,
    ["svelte"] = true,
    ["eslint"] = true,
    -- ["python"] = true
  }
  local drf = {}
  local dfv = df[client.name]
  if dfv ~= nil then
    client.resolved_capabilities.document_formatting = dfv
  end
  local drfv = drf[client.name]
  if drfv ~= nil then
    client.resolved_capabilities.document_range_formatting = drfv
  end

  local FormatAugroup = vim.api.nvim_create_augroup("Format", { clear = false })
  vim.api.nvim_clear_autocmds({
    buffer = bufnr,
    group = FormatAugroup,
  })
  vim.api.nvim_create_autocmd("BufWritePre", {
    callback = vim.lsp.buf.formatting_seq_sync,
    buffer = bufnr,
    group = FormatAugroup,
  })
  --protocol.SymbolKind = { }
  require("vim.lsp.protocol").CompletionItemKind = {
    "", -- Text
    "", -- Method
    "", -- Function
    "", -- Constructor
    "", -- Field
    "", -- Variable
    "", -- Class
    "ﰮ", -- Interface
    "", -- Module
    "", -- Property
    "", -- Unit
    "", -- Value
    "", -- Enum
    "", -- Keyword
    "﬌", -- Snippet
    "", -- Color
    "", -- File
    "", -- Reference
    "", -- Folder
    "", -- EnumMember
    "", -- Constant
    "", -- Struct
    "", -- Event
    "ﬦ", -- Operator
    "", -- TypeParameter
  }
  local _, ill_client = force_require("illuminate")
  if ill_client ~= nil then
    ill_client.on_attach(client)
  end
  local _, lsp_colors = force_require("lsp-colors")
  if lsp_colors ~= nil then
    lsp_colors.setup()
  end
end

local function loading()
  lsp_installer.settings({
    ui = {
      icons = {
        server_installed = "✓",
        server_pending = "➜",
        server_uninstalled = "✗",
      },
    },
  })
  lsp_installer.setup({})

  local servers = require("nvim-lsp-installer").get_installed_servers()
  for _, server in ipairs(servers) do
    local opts = server_opts[server.name] or {}
    opts.on_attach = on_attach
    opts.capabilities = generate_capabilities()
    lspconfig[server.name].setup(opts)
    vim.cmd([[ do User LspAttachBuffers ]])
  end
end

vim.api.nvim_create_autocmd("BufReadPre", {
  callback = loading,
  once = true,
})
