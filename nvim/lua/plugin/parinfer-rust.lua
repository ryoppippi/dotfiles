---@type LazySpec
return {
	"eraserhd/parinfer-rust",
	build = "nix develop --command bash -c 'cargo build --release'",
	ft = {
		"clojure",
		"scheme",
		"lisp",
		"racket",
		"hy",
		"fennel",
		"janet",
		"carp",
		"wast",
		"yuck",
		"dune",
	},
}
