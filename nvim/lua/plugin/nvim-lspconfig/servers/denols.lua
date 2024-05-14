local lsp_utils = require("plugin.nvim-lspconfig.utils")
local ft = lsp_utils.ft
local setup = lsp_utils.setup

---@param path string
local function findRootDirForDeno(path)
	---@type string|nil
	local project_root =
		vim.fs.root(path, vim.iter({ ".git", ft.deno_files, ft.node_specific_files }):flatten(math.huge):totable())
	project_root = project_root or vim.env.PWD

	local is_node_files_found = vim.iter(ft.node_specific_files):any(function(file)
		return vim.uv.fs_stat(vim.fs.joinpath(project_root, file)) ~= nil
	end)

	-- when node files not found, lauch denols
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

	-- stop denols if vtsls or tsserver is running
	vim.defer_fn(
		vim.schedule_wrap(function()
			local vtslsClients = vim.lsp.get_clients({ name = "vtsls", bufnr = 0 })
			local denoClients = vim.lsp.get_clients({ name = "denols", bufnr = 0 })
			local tsserverClients = vim.lsp.get_clients({ name = "tsserver", bufnr = 0 })
			if (#vtslsClients + #tsserverClients) > 0 and #denoClients > 0 then
				vim.iter(denoClients):each(function(client)
					client.stop()
				end)
			end
		end),
		1000
	)
	-- otherwise, return nil
	return nil
end

---@type LazySpec
return {
	name = "denols",
	dir = "",
	dependencies = {
		"neovim/nvim-lspconfig",
		"folke/neoconf.nvim",
	},
	ft = function(spec)
		return lsp_utils.get_default_filetypes(spec.name)
	end,
	opts = function()
		return {
			single_file_support = true,
			root_dir = function(path)
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
					suggest = {
						imports = {
							hosts = {
								["https://deno.land"] = true,
								["https://cdn.nest.land"] = true,
								["https://crux.land"] = true,
								["https://esm.sh"] = true,
							},
						},
					},
				},
			},
		}
	end,
	config = function(spec, opts)
		setup(spec.name, opts)
	end,
}
