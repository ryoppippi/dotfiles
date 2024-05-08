local utils = require("core.utils")
local lsp_utils = require("plugin.nvim-lspconfig.utils")
local setup = lsp_utils.setup

local function python_lsp_init(_, config)
	local lspconfig = require("lspconfig")
	config.settings.python.pythonPath = vim.env.VIRTUAL_ENV
			and lspconfig.util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
		or utils.find_cmd("python3", ".venv/bin", config.root_dir)
end

---@type LazySpec[]
return vim.iter({
	"pyright",
	"ruff",
	"ruff_lsp",
})
	:map(function(name)
		---@type LazySpec
		return {
			name = name,
			dir = "",
			dependencies = {
				"neovim/nvim-lspconfig",
				"cli",
			},
			ft = function(spec)
				return lsp_utils.get_default_filetypes(spec.name)
			end,
			config = function(spec, _)
				setup(spec.name, { before_init = python_lsp_init })
			end,
		}
	end)
	:totable()
