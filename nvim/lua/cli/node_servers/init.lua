return {
	name = "node_servers",
	dir = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h"),
	dependencies = { "nvim-lua/plenary.nvim" },
	build = "bun install",
	config = function(spec)
		local Path = require("plenary.path")
		local dir = spec.dir
		local BIN_DIR = Path:new(dir, "node_modules", ".bin")
		if not tb(BIN_DIR:exists()) then
			BIN_DIR:mkdir({ parents = true })
		end

		vim.env.PATH = BIN_DIR:absolute() .. ":" .. vim.env.PATH
		vim.system({ "bun", "i" }, { cwd = dir, text = true })
	end,
}
