return {
	"monaqa/dial.nvim",
	keys = {
		{
			"<C-a>",
			function()
				require("dial.map").manipulate("increment", "normal")
			end,
			mode = "n",
			desc = "dial increment",
		},
		{
			"<C-x>",
			function()
				require("dial.map").manipulate("decrement", "normal")
			end,
			mode = "n",
			desc = "dial decrement",
		},
		{
			"g<C-a>",
			function()
				require("dial.map").manipulate("increment", "gnormal")
			end,
			mode = "n",
			desc = "dial increment",
		},
		{
			"g<C-x>",
			function()
				require("dial.map").manipulate("decrement", "gnormal")
			end,
			mode = "n",
			desc = "dial decrement",
		},
		{
			"<C-a>",
			function()
				require("dial.map").manipulate("increment", "visual")
			end,
			mode = "v",
			desc = "dial increment",
		},
		{
			"<C-x>",
			function()
				require("dial.map").manipulate("decrement", "visual")
			end,
			mode = "v",
			desc = "dial decrement",
		},
		{
			"g<C-a>",
			function()
				require("dial.map").manipulate("increment", "gvisual")
			end,
			mode = "v",
			desc = "dial increment",
		},
		{
			"g<C-x>",
			function()
				require("dial.map").manipulate("decrement", "gvisual")
			end,
			mode = "v",
			desc = "dial decrement",
		},
	},
	config = function()
		local augend = require("dial.augend")

		local default = {
			augend.integer.alias.decimal,
			augend.integer.alias.hex,
			augend.integer.alias.binary,
			augend.date.alias["%Y/%m/%d"],
			augend.date.alias["%Y-%m-%d"],
			augend.date.alias["%Y年%-m月%-d日(%ja)"],
			augend.date.alias["%H:%M:%S"],
			augend.date.alias["%-m/%-d"],
			augend.constant.alias.ja_weekday,
			augend.constant.alias.ja_weekday_full,
			augend.hexcolor.new({ case = "lower" }),
			augend.semver.alias.semver,
			augend.constant.new({ elements = { "true", "false" }, cyclic = true }),
			augend.case.new({
				types = { "camelCase", "snake_case", "PascalCase", "SCREAMING_SNAKE_CASE" },
				cyclic = true,
			}),
		}

		require("dial.config").augends:register_group({
			default = default,
		})

		require("dial.config").augends:on_filetype(vim.iter({
			({
				f = function()
					local typescript = vim.iter({
						default,
						{
							augend.integer.alias.decimal,
							augend.integer.alias.hex,
							augend.paren.alias.quote,
							augend.constant.new({ elements = { "let", "const" } }),
						},
					})
						:flatten()
						:totable()
					local ft_table = {}
					for _, value in pairs({
						"typescript",
						"javascript",
						"typescriptreact",
						"javascriptreact",
						"tsx",
						"jsx",
						"svelte",
						"vue",
						"astro",
					}) do
						ft_table[value] = typescript
					end
					return ft_table
				end,
			}).f(),

			python = vim.iter({
				default,
				{ augend.constant.new({ elements = { "True", "False" }, cyclic = true }) },
			})
				:flatten()
				:totable(),
			markdown = vim.iter({
				default,
				{ augend.misc.alias.markdown_header },
			})
				:flatten()
				:totable(),
		})
			:flatten()
			:totable())

		require("core.utils").redetect_filetype()
	end,
}
