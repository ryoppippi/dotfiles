local o = {}
---@class LSPConfigOpts
o.lsp_opts = {}

---@return boolean 'is cmp installed?'
function o.has_cmp()
	return require("core.plugin").has("nvim-cmp")
end

o.lsp_opts.capabilities = vim.tbl_deep_extend(
	"force",
	{},
	vim.lsp.protocol.make_client_capabilities(),
	o.has_cmp() and require("cmp_nvim_lsp").default_capabilities() or {}
)
o.lsp_opts.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

o.html_like = {
	"astro",
	"html",
	"htmldjango",
	"css",
	"javascriptreact",
	"javascript.jsx",
	"typescriptreact",
	"typescript.tsx",
	"svelte",
	"vue",
	"markdown",
}

o.typescriptInlayHints = {
	parameterNames = {
		enabled = "literals", -- 'none' | 'literals' | 'all'
		suppressWhenArgumentMatchesName = true,
	},
	parameterTypes = { enabled = false },
	variableTypes = { enabled = false },
	propertyDeclarationTypes = { enabled = true },
	functionLikeReturnTypes = { enabled = false },
	enumMemberValues = { enabled = true },
}

function o.format_config(enabled)
	return function(client)
		client.server_capabilities.documentFormattingProvider = enabled
		client.server_capabilities.documentRangeFormattingProvider = enabled
	end
end

---Setup LSP client
---@param client any
---@param extra_opts LSPConfigOpts
function o.setup(client, extra_opts)
	if type(client) == "string" then
		client = require("lspconfig")[client]
	end

	local default_opts = client.document_config.default_config

	---@class LSPConfigOpts
	local local_opts = vim.tbl_deep_extend("force", {}, o.lsp_opts, extra_opts or {})

	local_opts.filetypes = vim.tbl_flatten({
		local_opts.filetypes or default_opts.filetypes or {},
		local_opts.extra_filetypes or {},
	})
	local_opts.extra_filetypes = nil
	client.setup(local_opts)
end

return o
