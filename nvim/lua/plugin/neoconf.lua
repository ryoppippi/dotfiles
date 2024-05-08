local convertT = {
	denols = "deno",
	vtsls = "tsserver",
}

---@param name string
local function checkEnable(name)
	name = assert(convertT[name] or name)

	local neoconf = require("neoconf")

	local schemaT = vim.iter({ "", "vscode", "coc", "lsp" }):map(function(key)
		return key == "" and name or ("%s.%s"):format(key, name)
	end)

	local allowKey = vim.iter(schemaT)
		:map(function(key)
			return ("%s.enable"):format(key)
		end)
		:totable()

	local disableKey = vim.iter(schemaT)
		:map(function(key)
			return ("%s.disable"):format(key)
		end)
		:totable()

	for _, key in ipairs(allowKey) do
		local res = neoconf.get(key)
		if res ~= nil then
			return res
		end
	end

	for _, key in ipairs(disableKey) do
		local res = neoconf.get(key)
		if res ~= nil then
			return not res
		end
	end

	return true
end

return {
	"folke/neoconf.nvim",
	-- dependencies = { "folke/neodev.nvim", config = true },
	config = function()
		local neoconf = require("neoconf")
		neoconf.setup({})

		require("core.plugin").on_attach(function(client, bufnr)
			local name = client.name

			vim.print(("%s-%s"):format(name, checkEnable(name)))
			if not checkEnable(name) then
				vim.lsp.buf_detach_client(bufnr, client.id)
			end
		end)
	end,
}
