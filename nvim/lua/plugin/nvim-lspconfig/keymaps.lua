local has = require("core.plugin").has
return {
  on_attach = function(_, bufnr)
    local opts = { silent = true, buffer = bufnr }
    local has_telescope = has("telescope.nvim")
    local has_action_preview = has("actions-preview.nvim")

    -- hover doc
    vim.keymap.set("n", "gh", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)

    -- jump to
    vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<cr>", opts)

    if has_telescope then
      vim.keymap.set("n", "gd", [[<cmd>Telescope lsp_definitions<cr>]], opts)
      vim.keymap.set("n", "gt", [[<cmd>Telescope lsp_type_definitions<cr>]], opts)
      vim.keymap.set("n", "gI", [[<cmd>Telescope lsp_implementations<cr>]], opts)
      vim.keymap.set("n", "gr", [[<cmd>Telescope lsp_references<cr>]], opts)
    else
      vim.keymap.set("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
      vim.keymap.set("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
      vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    end

    -- signature_help
    vim.keymap.set("i", "<C-k>", "<cmd>vim.lsp.buf.signature_help()<cr>", opts)
    vim.keymap.set("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)

    -- diagnostics
    vim.keymap.set("n", "gL", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
    if has_telescope then
      vim.keymap.set("n", "gl", [[<cmd>Telescope diagnostics<cr>]], opts)
    end

    vim.keymap.set("n", "-", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
    vim.keymap.set("n", "_", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)

    -- rename
    vim.keymap.set("n", "cW", function()
      if require("core.plugin").has("inc-rename.nvim") then
        require("inc_rename")
        -- if ir then
        return ":IncRename " .. vim.fn.expand("<cword>")
      end
      return vim.lsp.buf.rename
    end, { expr = true, buffer = bufnr, desc = "rename words" })

    -- code actions
    if not has_action_preview then
      vim.keymap.set({ "n", "v", "x" }, "ga", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    end

    -- workspace
    vim.keymap.set("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", opts)
    vim.keymap.set("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", opts)
    vim.keymap.set("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", opts)
  end,
}
