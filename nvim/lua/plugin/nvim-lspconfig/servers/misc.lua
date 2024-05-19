local lsp_utils = require("plugin.nvim-lspconfig.utils")
local ft = lsp_utils.ft
local format_config = lsp_utils.format_config
local setup = lsp_utils.setup

---@type LazySpec[]
return vim.iter({
	"nixd",
	"r_language_server",
	"sourcekit",
	"sqls",
	"taplo",
	"ruby_lsp",
	"prismals",
	"vuels",
	"angularls",
	{ "astro", format = false },
	{ "biome", format = false },
	{ "emmet_ls", format = false, extra_filetypes = ft.html_like },
	{ "tailwindcss", format = false, extra_filetypes = ft.css_like },
	{ "html", format = false },
	{ "stylelint_lsp", format = false },
})
	:map(function(tbl)
		---@type LazySpec
		return {
			name = type(tbl) == "string" and tbl or tbl[1],
			dir = "",
			dependencies = {
				"neovim/nvim-lspconfig",
				"cli",
				"node_servers",
			},
			ft = function(spec)
				if tbl.filetype ~= nil then
					return tbl.filetype
				end
				local dft = lsp_utils.get_default_filetypes(spec.name)
				if tbl.extra_filetypes ~= nil then
					return vim.iter({ dft, tbl.extra_filetypes }):flatten(math.huge):totable()
				end
				return dft
			end,
			opts = function()
				local opts = tbl.opts or {}
				if tbl.format ~= nil and tbl.format == false then
					table.insert(opts, { on_attach = format_config(false) })
				end
				return opts
			end,
			config = function(spec, opts)
				setup(spec.name, opts)
			end,
		}
	end)
	:totable()
