local lsp_utils = require("plugin.nvim-lspconfig.utils")
local ft = lsp_utils.ft

local function findRootDirForDeno(path)
	---@type string|nil
	local project_root =
		vim.fs.root(path, vim.iter({ ".git", ft.deno_files, ft.node_specific_files }):flatten(math.huge):totable())
	project_root = project_root or vim.env.PWD

	local is_node_files_found = vim.iter(ft.node_specific_files):any(function(file)
		return vim.uv.fs_stat(vim.fs.joinpath(project_root, file)) ~= nil
	end)

	-- when node files not found, launch denols
	if not is_node_files_found then
		local deps_path = vim.fs.joinpath(project_root, "deps.ts")
		if vim.uv.fs_stat(deps_path) ~= nil then
			vim.b[vim.fn.bufnr()].deno_deps_candidate = deps_path
		end
		return project_root
	end

	-- otherwise, return nil
	return nil
end

return {
	single_file_support = true,
	root_dir = function(bufnr, callback)
		local path = vim.fs.dirname(vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr)))
		return findRootDirForDeno(path)
	end,
	on_attach = function(_, buffer)
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
			buffer = buffer,
			callback = function()
				vim.cmd.DenolsCache()
			end,
		})
	end,
	settings = {
		deno = {
			lint = true,
			unstable = true,
		},
	},
}
