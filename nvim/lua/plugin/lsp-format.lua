---@type LazySpec
return {
	"https://github.com/lukas-reineke/lsp-format.nvim",
	config = true,
	lazy = false,
	init = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
				require("lsp-format").on_attach(client, args.buf)
			end,
		})
		vim.cmd([[cabbrev wq execute "Format sync" <bar> wq]])
		vim.cmd([[cabbrev wqa execute "Format sync" <bar> wqa]])
	end,
}
