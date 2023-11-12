return {
	"monaqa/dial.nvim",
	keys = { "<C-a>", "<C-x>", "g<C-a>", "g<C-x>" },
	config = function()
		local au_dial = vim.api.nvim_create_augroup("dial", { clear = true })

		local function keymap(group_name)
			vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(group_name), {})
			vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(group_name), {})
			vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual(group_name), {})
			vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual(group_name), {})
			vim.keymap.set("v", "g<C-a>", require("dial.map").inc_gvisual(group_name), {})
			vim.keymap.set("v", "g<C-x>", require("dial.map").dec_gvisual(group_name), {})
		end

		local function set_filetype_autocmd(filetype)
			vim.api.nvim_create_autocmd("Filetype", {
				pattern = filetype,
				callback = function()
					keymap(filetype)
				end,
				group = au_dial,
			})
		end

		keymap()

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

		local typescript = {
			augend.integer.alias.decimal,
			augend.integer.alias.hex,
			augend.constant.new({ elements = { "let", "const" } }),
		}

		require("dial.config").augends:register_group({
			default = default,
		})

		require("dial.config").augends:on_filetype({
			typescript = typescript,
			javascript = typescript,
			typescriptreact = typescript,
			javascriptreact = typescript,
			tsx = typescript,
			jsx = typescript,
			svelte = typescript,
			vue = typescript,
			astro = default,
		})

		require("core.utils").redetect_filetype()
	end,
}
