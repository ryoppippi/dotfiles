return {
	"SmiteshP/nvim-navic",
	dependencies = {
		"neovim/nvim-lspconfig",
		"onsails/lspkind.nvim",
	},
	init = function()
		vim.g.navic_silence = true

		require("core.plugin").on_attach(function(client, bufnr)
			if client.server_capabilities.documentSymbolProvider then
				require("nvim-navic").attach(client, bufnr)
			end
		end)
	end,
	config = function()
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
