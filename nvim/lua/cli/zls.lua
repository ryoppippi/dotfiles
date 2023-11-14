return {
	"zigtools/zls",
	build = {
		"bun x @oven/zig build -Doptimize=ReleaseSafe --verbose",
	},
	config = function(spec)
		local dir = spec.dir
		vim.system({ "bun", "i" }, { cwd = dir .. "/zig-out/bin", text = true })
	end,
}
