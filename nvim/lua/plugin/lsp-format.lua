return {
	"lukas-reineke/lsp-format.nvim",
	opts = { sync = true },
	enabled = false,
	init = function()
		local on_attach = require("core.plugin").on_attach
		on_attach(function(client, _)
			local enableFormat = client.server_capabilities.documentFormattingProvider
			if enableFormat then
				require("lsp-format").on_attach(client)
				-- vim.cmd([[
				--       cabbrev wq execute "Format sync" <bar> wq
				--       cabbrev wqa bufdo execute "Format sync" <bar> wa <bar> q
				--     ]])
			end
		end)
	end,
}
