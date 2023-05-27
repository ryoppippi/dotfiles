return {
	"RRethy/vim-illuminate",
	init = function()
		vim.g.Illuminate_delay = 500
		require("core.plugin").on_attach(function(client, _)
			require("illuminate").on_attach(client)
		end)
	end,
}
