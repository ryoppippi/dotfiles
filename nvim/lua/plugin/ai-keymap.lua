return {
	"ryoppippi/nvim-in-the-loop",
	dir = "~/ghq/github.com/ryoppippi/nvim-in-the-loop",
	dev = true,
	event = "VeryLazy",
	build = "bun install",
	config = function()
		require("ai_keymap").setup({
			log_path = vim.fn.stdpath("data") .. "/ai_keymap/keystrokes.jsonl",
			visualize_cmd = { "bun", "run", "src/cli.ts" },
			visualize_args = { "--dotfiles", vim.fn.expand("~/.config/nvim") },
			suggest_args = { "--dotfiles", vim.fn.expand("~/.config/nvim"), "--model", "gpt-4-turbo" },
		})
	end,
}
