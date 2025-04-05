local convertT = {
	denols = "deno",
	vtsls = "tsserver",
}

---@param key string
local function getOptions(key)
	local neoconf = require("neoconf")

	local schemaT = vim.iter({ "", "vscode", "coc", "nlsp" }):map(function(configType)
		return configType == "" and key or ("%s.%s"):format(configType, key)
	end)

	---@type nil|string|table|integer|boolean
	local item = vim.iter(schemaT)
		:map(function(item)
			return neoconf.get(item)
		end)
		:find(function(item)
			return item ~= nil
		end)
	return item
end

--@param name string
local function isClientEnable(name)
	name = assert(convertT[name] or name)
	local enable = getOptions(name .. ".enable")
	local disable = getOptions(name .. ".disable")
	if enable == nil and disable == nil then
		return nil
	end

	local isEnable = enable == true or disable == false
	return isEnable
end

---@type LazySpec
return {
	"folke/neoconf.nvim",
	-- dependencies = { "folke/neodev.nvim", config = true },
	opts = {},
	config = function(_, opts)
		local neoconf = require("neoconf")
		neoconf.setup(opts)

		require("core.plugin").on_attach(function(client, bufnr)
			local name = client.name
			local isEnable = isClientEnable(name)

			if isEnable == false then
				vim.lsp.buf_detach_client(bufnr, client.id)
			end
		end)
	end,
	isClientEnable = isClientEnable,
	getOptions = getOptions,
}
