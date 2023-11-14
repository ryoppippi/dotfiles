return {
	"RubixDev/mason-update-all",
	cond = not is_vscode(),
	enabled = false,
	cmd = { "MasonUpdateAll" },
	dependencies = {
		"williamboman/mason.nvim",
	},
	config = true,
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyUpdate",
			callback = function()
				require("mason-update-all").update_all()
			end,
			desc = "Run mason-update-all after LazyUpdate",
		})
	end,
}
