-- detach denols if vtsls or tsserver is running. If no buffer is attached to denols, stop the client
require("core.plugin").on_attach(function(client, bufnr)
	local node_servers = { "vtsls", "tsserver" }

	if not vim.iter({ node_servers, "denols" }):flatten(math.huge):any(function(s)
		return client.name == s
	end) then
		return
	end

	-- if client.root_dir ~= nil then
	-- 	return
	-- end

	vim.schedule(function()
		---@type vim.lsp.Client[]
		local nodeLSPs = vim.iter({ "vtsls", "tsserver" })
			:map(function(cn)
				return vim.lsp.get_clients({ name = cn, bufnr = bufnr })
			end)
			:flatten()
			:totable()
		local denoLSPs = vim.lsp.get_clients({ name = "denols", bufnr = bufnr })
		if #nodeLSPs > 0 and #denoLSPs > 0 then
			vim.iter(denoLSPs):each(function(denoLSP)
				vim.lsp.stop_client(denoLSP.id)
				if #denoLSP.attached_buffers < 1 then
					vim.lsp.stop_client(denoLSP.id)
				end
			end)
		end
	end)
end)

---@type vim.lsp.Config
return {
	single_file_support = true,
	workspace_required = false,
	settings = {
		deno = {
			lint = true,
			unstable = true,
		},
	},
}
