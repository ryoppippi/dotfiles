return {
	"echasnovski/mini.trailspace",
	branch = "stable",
	keys = { "TrimSpace" },
	init = function()
		vim.api.nvim_create_user_command("TrimSpace", function()
			require("mini.trailspace").trim()
		end, {})
	end,
	config = function(_, opts)
		require("mini.trailspace").setup(opts)
	end,
}
