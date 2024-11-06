local sveltekit_target = {
	{ target = "/%1/%+%2.svelte", context = "view" },
	{ target = "/%1/%+%2\\(*.ts\\|*.js\\)", context = "script", transformer = "remove_server" },
	{ target = "/%1/%+%2\\(*.ts\\|*.js\\)", context = "script", transformer = "add_server" },
}

---@type LazySpec
return {
	"rgroli/other.nvim",
	cmd = { "Other", "OtherClear", "OtherSplit", "OtherVSplit" },
	commit = "d36a66a",
	keys = {
		{ "<leader><TAB>", "<cmd>Other<CR>" },
		{ "soo", "<cmd>Other<CR>" },
		{ "sov", "<cmd>OtherVSplit<CR>" },
		{ "sos", "<cmd>OtherSplit<CR>" },
	},
	opts = {
		mappings = {
			-- builtin mappings
			"livewire",
			"angular",
			"laravel",

			-- sveltekit
			{
				pattern = "/(.*)/%+(.*).server.ts$",
				target = sveltekit_target,
			},
			{
				pattern = "/(.*)/%+(.*).server.js$",
				target = sveltekit_target,
			},
			{
				pattern = "/(.*)/%+(.*).ts$",
				target = sveltekit_target,
			},
			{
				pattern = "/(.*)/%+(.*).js$",
				target = sveltekit_target,
			},
			{
				pattern = "/(.*)/%+(.*).svelte$",
				target = sveltekit_target,
			},
		},
		transformers = {
			-- remove `server` from the path
			remove_server = function(inputString)
				return inputString:gsub("server", "")
			end,
			-- add `server` to the path
			-- ex: +page.ts -> +page.server.ts
			-- ex: +page.js -> +page.server.js
			add_server = function(inputString)
				return inputString:gsub("%.(ts|js)$", ".server.%1")
			end,
		},
	},
	config = function(_, opt)
		require("other-nvim").setup(opt)
	end,
}
