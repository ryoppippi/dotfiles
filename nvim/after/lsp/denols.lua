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

	-- if node files found, check if deno is enabled for this project
	-- check .vscode/settings.json or .neoconf.json for deno.enable and deno.enablePaths
	local getOptions = require("plugin.neoconf").getOptions
	local enable = getOptions("deno.enable")
	local enable_paths = getOptions("deno.enablePaths")
	if enable ~= false and type(enable_paths) == "table" then
		local root_in_enable_path = vim.iter(enable_paths)
			:map(function(p)
				return vim.fs.joinpath(project_root, p)
			end)
			:find(function(absEnablePath)
				return vim.startswith(path, absEnablePath)
			end)
		if root_in_enable_path ~= nil then
			local deps_path = vim.fs.joinpath(root_in_enable_path, "deps.ts")
			if vim.uv.fs_stat(deps_path) ~= nil then
				vim.b[vim.fn.bufnr()].deno_deps_candidate = deps_path
			end
			return root_in_enable_path
		end
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
