return {
	"aznhe21/actions-preview.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-telescope/telescope.nvim",
	},
	event = "LspAttach",
	init = function()
		require("core.plugin").on_attach(function(_, buffer)
			local key_opt = { silent = true, buffer = buffer }
			vim.keymap.set({ "n", "v", "x" }, "ga", require("actions-preview").code_actions, key_opt)
		end)
	end,
	opts = function()
		return {
			telescope = require("telescope.themes").get_dropdown({ winblend = 10 }),
		}
	end,
}
