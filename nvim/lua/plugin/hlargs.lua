return {
	"m-demare/hlargs.nvim",
	event = "BufReadPost",
	config = function()
		local hla = require("hlargs")
		hla.setup()
		hla.enable()
		vim.api.nvim_create_autocmd("colorscheme", {
			pattern = "*",
			callback = function()
				hla.enable()
			end,
		})
	end,
}
