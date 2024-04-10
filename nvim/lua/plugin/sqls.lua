---@type LazySpec
return {
	"nanotee/sqls.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	ft = { "sql" },
	config = function()
		require("core.plugin").on_attach(function(client, bufnr)
			if client.name == "sqls" then
				require("sqls").on_attach(client, bufnr)
			end
		end)
	end,
}
