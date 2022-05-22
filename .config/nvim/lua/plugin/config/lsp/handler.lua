local M = {}
local force_require = require("utils.plugin").force_require

local FormatAugroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })

local function set_keymap(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- hover doc
  vim.keymap.set("n", "gh", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)

  -- jump to
  -- vim.keymap.set("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<cr>", opts)
  vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<cr>", opts)
  -- vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
  -- vim.keymap.set("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
  -- vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
  vim.keymap.set("n", "gd", [[<cmd>Telescope lsp_definitions<cr>]], opts)
  vim.keymap.set("n", "gt", [[<cmd>Telescope lsp_type_definitions<cr>]], opts)
  vim.keymap.set("n", "gI", [[<cmd>Telescope lsp_implementations<cr>]], opts)
  vim.keymap.set("n", "gr", [[<cmd>Telescope lsp_references<cr>]], opts)

  -- signature_help
  vim.keymap.set("i", "<C-k>", "<cmd>vim.lsp.buf.signature_help()<cr>", opts)
  vim.keymap.set("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)

  -- diagnostics
  vim.keymap.set("n", "gj", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
  vim.keymap.set("n", "gJ", [[<cmd>Telescope diagnostics<cr>]], opts)
  vim.keymap.set("n", "-", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
  vim.keymap.set("n", "_", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
  -- vim.keymap.set("n", "gl", "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", opts)

  -- rename
  vim.keymap.set("n", "cW", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)

  -- code actions
  vim.keymap.set("n", "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

  -- workspace
  vim.keymap.set("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", opts)
  vim.keymap.set("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", opts)
  vim.keymap.set("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", opts)

  -- formatting
  vim.keymap.set("n", "<leader>zz", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
  vim.keymap.set("n", "<leader>zx", "<cmd>lua vim.lsp.buf.range_formatting()<cr>", opts)
end

local function set_sign(client, bufnr)
  vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
  vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
  vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
  vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })
end

local function set_options(client, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- signature help
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    silent = true,
    focusable = false,
  })
end

local function set_formatting(client, bufnr)
  local name = client.name

  local document_formatting_disable_list = { "tsserver", "svelte" }
  local document_range_formatting_disable_list = { "tsserver", "svelte" }

  for _, v in ipairs(document_formatting_disable_list) do
    if v == name then
      client.resolved_capabilities.document_formatting = false
    end
  end
  for _, v in ipairs(document_range_formatting_disable_list) do
    if v == name then
      client.resolved_capabilities.document_range_formatting = false
    end
  end

  -- auto formatting
  if client.supports_method("textDocument/formatting") and client.resolved_capabilities.document_formatting then
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
end

local function set_protocol(client, bufnr)
  local protocol = vim.lsp.protocol

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
end

local function set_aditional_plugins(client, bufnr)
  local ill_status, ill_client = force_require("illuminate")
  if ill_status and ill_client ~= nil then
    ill_client.on_attach(client)
  end
end

local gen_capabilities = function()
  local protocol = vim.lsp.protocol
  local capabilities = protocol.make_client_capabilities()

  local status, cmp_nvim_lsp = force_require("cmp_nvim_lsp")
  if status and cmp_nvim_lsp ~= nil then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end
  return capabilities
end

M.on_attach = function(client, bufnr)
  set_keymap(client, bufnr)
  set_options(client, bufnr)
  set_sign(client, bufnr)
  set_formatting(client, bufnr)
  set_protocol(client, bufnr)
  set_aditional_plugins(client, bufnr)
end

M.capabilities = gen_capabilities()

return M
