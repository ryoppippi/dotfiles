return {
	name = "node_servers",
	dir = vim.fn.stdpath("config") .. "/lua/cli/node_servers",
	build = "bun install",
	config = function(spec)
		local dir = spec.dir
		local BIN_DIR = dir .. "/node_modules/.bin"
		if not tb(vim.fn.isdirectory(BIN_DIR)) then
			vim.fn.mkdir(BIN_DIR, "p")
		end

		vim.env.PATH = BIN_DIR .. ":" .. vim.env.PATH
		vim.system({ "bun", "i" }, { cwd = dir, text = true })
	end,
}
