return {
	"willothy/flatten.nvim",
	lazy = false,
	priority = 1001,
	-- setup() must run for the terminal socket hook to be installed;
	-- without opts the spec loads but flatten never activates
	opts = {},
}
