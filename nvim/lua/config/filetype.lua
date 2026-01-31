vim.filetype.add({
	extension = {
		jax = "help",
		kbd = "lisp",
		mdx = "markdown",
		zon = "zig",
	},
	filename = {
		[".envrc"] = "sh",
		["tsconfig.json"] = "jsonc",
		["mdx"] = "markdown",
	},
	pattern = {
		[".*/%.git/config"] = "gitconfig",
		[".*/%.git/.*%.conf"] = "gitconfig",
		[".*/git/config"] = "gitconfig",
		[".*/git/.*%.conf"] = "gitconfig",

		[".*/%.git/ignore"] = "gitignore",
		[".*/git/ignore"] = "gitignore",

		[".*/%.ssh/config"] = "sshconfig",

		[".*/%.ssh/.*%.conf"] = "sshconfig",
		[".*/ssh/.*%.conf"] = "sshconfig",

		[".*/env.development"] = "sh",
		[".*/env.production"] = "sh",
		[".*/env.staging"] = "sh",
		[".*/env.local"] = "sh",
		[".*/%.env%.local"] = "sh",
		[".*/%.env%.development"] = "sh",
		[".*/%.env%.production"] = "sh",
		[".*/%.env%.staging"] = "sh",

		[".*/Dockerfile.*"] = "dockerfile",
	},
})
