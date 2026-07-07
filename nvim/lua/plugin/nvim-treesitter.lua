return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	dependencies = {
		-- textobj
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			config = function()
				require("nvim-treesitter-textobjects").setup({
					select = {
						lookahead = true,
					},
					move = {
						set_jumps = true,
					},
				})

				local select = require("nvim-treesitter-textobjects.select").select_textobject
				local keymaps = {
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ai"] = "@conditional.outer",
					["ii"] = "@conditional.inner",
					["aC"] = "@class.outer",
					["iC"] = "@class.inner",
					["ac"] = "@comment.outer",
					["ic"] = "@comment.inner",
					["ab"] = "@block.outer",
					["ib"] = "@block.inner",
					["al"] = "@loop.outer",
					["il"] = "@loop.inner",
					["ip"] = "@parameter.inner",
					["ap"] = "@parameter.outer",
				}
				for key, query in pairs(keymaps) do
					vim.keymap.set({ "x", "o" }, key, function()
						select(query, "textobjects")
					end)
				end

				vim.keymap.set("n", "<leader>>", function()
					require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
				end)
				vim.keymap.set("n", "<leader><", function()
					require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
				end)

				local move = require("nvim-treesitter-textobjects.move")
				vim.keymap.set({ "n", "x", "o" }, "]f", function()
					move.goto_next_start("@function.outer", "textobjects")
				end)
				vim.keymap.set({ "n", "x", "o" }, "]c", function()
					move.goto_next_start("@conditional.outer", "textobjects")
				end)
				vim.keymap.set({ "n", "x", "o" }, "]F", function()
					move.goto_next_end("@function.outer", "textobjects")
				end)
				vim.keymap.set({ "n", "x", "o" }, "]C", function()
					move.goto_next_end("@conditional.outer", "textobjects")
				end)
				vim.keymap.set({ "n", "x", "o" }, "[f", function()
					move.goto_previous_start("@function.outer", "textobjects")
				end)
				vim.keymap.set({ "n", "x", "o" }, "[c", function()
					move.goto_previous_start("@conditional.outer", "textobjects")
				end)
				vim.keymap.set({ "n", "x", "o" }, "[F", function()
					move.goto_previous_end("@function.outer", "textobjects")
				end)
				vim.keymap.set({ "n", "x", "o" }, "[C", function()
					move.goto_previous_end("@conditional.outer", "textobjects")
				end)
			end,
		},
		{ "David-Kunz/treesitter-unit" },

		-- UI
		{ "haringsrob/nvim_context_vt" },
	},
	config = function()
		require("nvim-treesitter").setup({
			auto_install = false,
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				-- With commit.verbose=true, merge commit buffers contain the full
				-- merge diff, and parsing it makes the editor slow to open
				if args.match == "gitcommit" then
					return
				end
				if vim.api.nvim_buf_line_count(args.buf) <= 50000 then
					pcall(vim.treesitter.start, args.buf)
				end
			end,
		})
	end,
}
