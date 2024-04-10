---@type LazySpec
return {
	"eraserhd/parinfer-rust",
	build = "cargo build --release --locked",
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
