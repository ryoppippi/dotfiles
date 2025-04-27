local o = {}

---@return boolean 'is cmp installed?'
function o.has_cmp()
	return require("core.plugin").has("nvim-cmp")
end

---Typescript inlay hints confis
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

---Format config
---@param enabled boolean
function o.format_config(enabled)
	return function(client)
		client.server_capabilities.documentFormattingProvider = enabled
		client.server_capabilities.documentRangeFormattingProvider = enabled
	end
end

return o
