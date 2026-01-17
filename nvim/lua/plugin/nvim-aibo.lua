return {
	"lambdalisue/nvim-aibo",
	cmd = { "Aibo", "AiboSend" },
	config = function()
		require("aibo").setup()
	end,
}
