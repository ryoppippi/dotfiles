return {
	"lewis6991/hover.nvim",
	event = "LspAttach",
	keys = {
		{
			"gh",
			function()
				require("hover").hover()
			end,
			{ desc = "hover" },
		},
	},
	opts = function()
		return {
			init = function()
				-- Require providers
				require("hover.providers.lsp")
				require("hover.providers.gh")
				require("hover.providers.gh_user")
				-- require('hover.providers.jira')
				-- require('hover.providers.man')
				-- require('hover.providers.dictionary')
			end,
		}
	end,
}
