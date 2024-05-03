return {
	name = "node_servers",
	dir = vim.fn.fnamemodify(debug.getinfo(1).source:sub(2), ":h"),
	build = "bun install",
	config = function(spec)
		local dir = spec.dir

		vim.system({ "bun", "i" }, { cwd = dir, text = true }, _l("obj: vim.print(obj.stdout)"))

		local BIN_DIR =
			assert((vim.system({ "bun", "pm", "bin" }, { cwd = dir, text = true }):wait()).stdout):gsub("\n[^\n]*$", "")
		vim.env.PATH = ("%s:%s"):format(BIN_DIR, vim.env.PATH)
	end,
}
