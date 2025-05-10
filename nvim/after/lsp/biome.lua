---@type vim.lsp.Config
return {
	workspace_required = true,
	cmd = { "./node_modules/.bin/biome", "lsp-proxy" },
}
