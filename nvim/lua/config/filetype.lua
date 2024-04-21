vim.filetype.add({
	extension = {
		jax = "help",
		zon = "zig",
	},
	filename = {
		[".envrc"] = "sh",
		["tsconfig.json"] = "jsonc",
		["bun.lockb"] = "bunlockb",
	},
	pattern = {
		[".*/%.git/config"] = "gitconfig",
		[".*/%.git/.*%.conf"] = "gitconfig",
		[".*/git/config"] = "gitconfig",
		[".*/git/.*%.conf"] = "gitconfig",

		[".*/%.git/ignore"] = "gitignore",
		[".*/git/ignore"] = "gitignore",

		["./*/tmux/tmux"] = "tmux",
		[".*/tmux/tmux"] = "tmux",

		[".*/%.ssh/config"] = "sshconfig",

		[".*/%.ssh/.*%.conf"] = "sshconfig",
		[".*/ssh/.*%.conf"] = "sshconfig",
	},
})
