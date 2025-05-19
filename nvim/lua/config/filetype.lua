vim.filetype.add({
	extension = {
		jax = "help",
		zon = "zig",
		mdx = "markdown",
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
	},
})
