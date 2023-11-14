local M = {}

M.python_lsp_init = function(_, config)
	local lspconfig = require("lspconfig")
	local utils = require("core.utils")

	config.settings.python.pythonPath = vim.env.VIRTUAL_ENV
			and lspconfig.util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
		or utils.find_cmd("python3", ".venv/bin", config.root_dir)
end

return M
