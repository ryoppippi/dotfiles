local M = {}
local force_require = require("utils.plugin").force_require

-- local FormatAugroup = vim.api.nvim_create_augroup("LspFormatting", { clear = false })

local function set_keymap(client, bufnr)
  local opts = { silent = true, buffer = bufnr }

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
  vim.keymap.set("n", "gL", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
  vim.keymap.set("n", "gl", [[<cmd>Telescope diagnostics <cr>]], opts)
  vim.keymap.set("n", "-", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
  vim.keymap.set("n", "_", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)

  -- rename
  -- vim.keymap.set("n", "cW", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
  vim.keymap.set("n", "cW", function()
    if vim.fn.exists(":IncRename") then
      return ":IncRename " .. vim.fn.expand("<cword>")
    end
    return "<cmd>lua vim.lsp.buf.rename()<cr>"
  end, { expr = true, buffer = bufnr, desc = "rename words" })

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
  local document_formatting_disable_list = { "tsserver", "svelte", "sumneko_lua" }

  if vim.tbl_contains(document_formatting_disable_list, client.name) then
    return
  end

  -- auto formatting
  if client.supports_method("textDocument/formatting") then
    -- vim.api.nvim_clear_autocmds({
    --   buffer = bufnr,
    --   group = FormatAugroup,
    -- })
    -- vim.api.nvim_create_autocmd("BufWritePre", {
    --   callback = vim.lsp.buf.formatting_seq_sync,
    --   buffer = bufnr,
    --   group = FormatAugroup,
    -- })
    local lsp_format = force_require("lsp-format")
    if lsp_format then
      lsp_format.on_attach(client)
      vim.cmd([[
        cabbrev wq execute "Format sync" <bar> wq
        cabbrev wqa bufdo execute "Format sync" <bar> wa <bar> q
      ]])
    end
  end
end

local function set_plugins(client, bufnr)
  local illuminate = force_require("illuminate")
  if illuminate then
    illuminate.on_attach(client)
  end

  -- local aerial = force_require("aerial")
  -- if aerial then
  --   aerial.on_attach(client, bufnr)
  -- end

  local navic = force_require("nvim-navic")
  if navic then
    navic.attach(client, bufnr)
  end
end

local gen_capabilities = function()
  local protocol = vim.lsp.protocol
  local capabilities = protocol.make_client_capabilities()

  local cmp_nvim_lsp = force_require("cmp_nvim_lsp")
  if cmp_nvim_lsp then
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
  end
  return capabilities
end

M.on_attach = function(client, bufnr)
  set_keymap(client, bufnr)
  set_options(client, bufnr)
  set_formatting(client, bufnr)
  set_plugins(client, bufnr)
end

M.capabilities = gen_capabilities()

return M
