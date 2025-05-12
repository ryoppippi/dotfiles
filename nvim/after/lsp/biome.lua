---@type vim.lsp.Config
return {
	workspace_required = true,
	root_dir = function(bufnr, on_dir)
		local found_dirs = vim.fs.find({
			"biome.json",
			"biome.jsonc",
		}, {
			upward = true,
			path = vim.fs.dirname(vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))),
		})
		if #found_dirs > 0 then
			return on_dir(vim.fs.dirname(found_dirs[1]))
		end
	end,
}
