return {
	"uga-rosa/ugaterm.nvim",
	cmd = { "UgatermOpen", "UgatermSend" },
	keys = {
		{ "<c-z>", "<cmd>UgatermOpen -toggle<cr>", mode = { "n", "t" } },
	},
}
