---@type OnAttachCallback
local on_attach = function(client, bufnr)
	require("plugin.nvim-lspconfig.on_attach.keymaps").on_attach(client, bufnr)
	require("plugin.nvim-lspconfig.on_attach.diagnostic").on_attach(client, bufnr)
	require("plugin.nvim-lspconfig.on_attach.inlayhints").on_attach(client, bufnr)
end

return on_attach
