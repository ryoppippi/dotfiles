return {
	"hrsh7th/nvim-insx",
	event = { "InsertEnter" },
	config = function()
		require("insx.preset.standard").setup()
	end,
}
