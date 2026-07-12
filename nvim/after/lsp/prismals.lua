local lsp_utils = require("plugin.nvim-lspconfig.utils")

---@type vim.lsp.Config
return {
	cmd = lsp_utils.node_modules_cmd("prisma-language-server", { "--stdio" }),
}
