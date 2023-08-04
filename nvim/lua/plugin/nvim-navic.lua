return {
	"SmiteshP/nvim-navic",
	cond = not is_vscode(),
	dependencies = {
		"neovim/nvim-lspconfig",
		"onsails/lspkind.nvim",
	},
	init = function()
		require("core.plugin").on_attach(function(client, bufnr)
			if vim.g.navic_silence and client.server_capabilities.documentSymbolProvider then
				require("nvim-navic").attach(client, bufnr)
			end
		end)
	end,
	config = function()
		vim.g.navic_silence = true

		local symbol_map = {}
		for key, value in pairs(require("lspkind").symbol_map) do
			symbol_map[key] = value .. " "
		end

		require("nvim-navic").setup({
			icons = symbol_map,
			highlight = false,
			separator = " > ",
			depth_limit = 0,
			depth_limit_indicator = "..",
		})
	end,
}
