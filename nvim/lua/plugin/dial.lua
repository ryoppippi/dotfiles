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
		local config = require("dial.config")

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

		config.augends:register_group({
			default = default,
		})

		config.augends:on_filetype({
			python = vim.iter({
				default,
				{ augend.constant.new({ elements = { "True", "False" }, cyclic = true }) },
			})
				:flatten()
				:totable(),
		})
		config.augends:on_filetype({
			zig = vim.iter({
				default,
				{ augend.constant.new({ elements = { "var", "const" }, cyclic = true }) },
			})
				:flatten()
				:totable(),
		})

		config.augends:on_filetype({
			markdown = vim.iter({
				default,
				{ augend.misc.alias.markdown_header },
			})
				:flatten()
				:totable(),
		})

		local typescriptGroup = vim.iter({
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

		vim.iter({
			"typescript",
			"javascript",
			"typescriptreact",
			"javascriptreact",
			"tsx",
			"jsx",
			"svelte",
			"vue",
			"astro",
		}):each(function(ft)
			config.augends:on_filetype({
				[ft] = typescriptGroup,
			})
		end)

		require("core.utils").redetect_filetype()
	end,
}
