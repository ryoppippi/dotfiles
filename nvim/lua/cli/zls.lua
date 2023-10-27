return {
	"zigtools/zls",
	build = {
		"bun x @oven/zig build -Doptimize=ReleaseSafe --verbose",
	},
}
