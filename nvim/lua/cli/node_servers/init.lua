return {
	name = "node_servers",
	dir = vim.fn.stdpath("config") .. "/lua/cli/node_servers",
	build = "bun install",
	init = function(spec)
		local BIN_DIR = spec.dir .. "/node_modules/.bin"

		if tb(vim.fn.isdirectory(BIN_DIR)) then
			vim.env.PATH = BIN_DIR .. ":" .. vim.env.PATH
		end

		vim.defer_fn(function()
			vim.system({ "bun", "i" }, { cwd = spec.dir, text = true })
			vim.env.PATH = BIN_DIR .. ":" .. vim.env.PATH
		end, 0)
	end,
}
