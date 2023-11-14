return {
	name = "python_tools",
	dir = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h"),
	build = function(spec)
		vim.system({ "rye", "sync" }, { cwd = spec.dir, text = true })
	end,
	config = function(spec)
		local BIN_DIR = spec.dir .. "/.venv/bin/"

		vim.env.PATH = BIN_DIR .. ":" .. vim.env.PATH
	end,
}
