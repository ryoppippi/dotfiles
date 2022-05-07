local on_attach = function(client, bufnr)
  local force_require = require("utils.plugin").force_require
  local _, lspconfig = force_require("lspconfig")
  local lsp_util = lspconfig.util
  local protocol = vim.lsp.protocol

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
  vim.keymap.set("i", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  -- vim.keymap.set("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
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

  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({
      buffer = bufnr,
      group = FormatAugroup,
    })
    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = vim.lsp.buf.formatting_seq_sync,
      buffer = bufnr,
      group = FormatAugroup,
    })
  end
  --protocol.SymbolKind = { }
  protocol.CompletionItemKind = {
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

return on_attach
