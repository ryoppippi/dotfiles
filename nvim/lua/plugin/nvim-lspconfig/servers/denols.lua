local lsp_utils = require("plugin.nvim-lspconfig.utils")
local ft = lsp_utils.ft
local setup = lsp_utils.setup

local filetypes = ft.js_like

---@type LazySpec
return {
	name = "denols",
	dir = "",
	dependencies = {
		"neovim/nvim-lspconfig",
		"kyoh86/climbdir.nvim",
	},
	ft = filetypes,
	opts = function()
		return {
			filetypes = filetypes,
			single_file_support = true,
			root_dir = function(path)
				local marker = require("climbdir.marker")
				local found = require("climbdir").climb(
					path,
					marker.one_of(
						marker.has_readable_file("deno.json"),
						marker.has_readable_file("deno.jsonc"),
						marker.has_directory("denops")
					),
					{
						halt = marker.one_of(
							marker.has_readable_file("package.json"),
							marker.has_directory("node_modules")
						),
					}
				)
				if found then
					vim.b[vim.fn.bufnr()].deno_deps_candidate = vim.fs.joinpath(found, "deps.ts")
				end
				return found
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
