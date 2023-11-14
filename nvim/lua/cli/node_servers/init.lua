local CONFIG_DIR = vim.fn.stdpath("config")
local NODE_SERVERS_DIR = CONFIG_DIR .. "/lua/cli/node_servers"

return {
	name = "node_servers",
	dir = "",
	build = function()
		vim.system({ "bun", "install" }, { cwd = NODE_SERVERS_DIR, text = true })
	end,

	init = function()
		-- add ./node_modules/.bin to $PATH
		local BIN_DIR = NODE_SERVERS_DIR .. "/node_modules/.bin"
		vim.env.PATH = BIN_DIR .. ":" .. vim.env.PATH

		vim.system({ "bun", "i" }, { cwd = BIN_DIR, text = true })
	end,
}
