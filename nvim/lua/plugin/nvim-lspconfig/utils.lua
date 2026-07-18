local o = {}

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

---Create an LSP command that prefers a project-local Node.js binary.
---@param binary string executable name within node_modules/.bin
---@param args string[] command arguments
---@return function cmd function accepted by vim.lsp.Config
function o.node_modules_cmd(binary, args)
	return function(dispatchers, config)
		local executable = binary
		if (config or {}).root_dir then
			local local_bin = vim.fs.joinpath(config.root_dir, "node_modules/.bin", binary)
			if vim.fn.executable(local_bin) == 1 then
				executable = local_bin
			end
		end

		return vim.lsp.rpc.start(vim.list_extend({ executable }, args), dispatchers)
	end
end

return o
