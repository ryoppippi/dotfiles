local dependencies = { "monaqa/peridot.vim", "nvim-lua/plenary.nvim" }

---@type LazySpec
return {
	{
		dir = "",
		name = "ryoppippi-append-new-lines",
		dependencies = dependencies,
		keys = {
			"<leader>o",
			"<leader>O",
		},
		config = function()
			local function append_new_lines(offset_line)
				local peridot = require("peridot")
				local i = require("plenary.iterators")
				return peridot
					and peridot.repeatable_edit(function(ctx)
						local curpos = vim.fn.line(".")
						local pos_line = curpos + offset_line
						local n_lines = ctx.count1
					-- stylua: ignore
					local lines = i.range(n_lines):map(function() return "" end):tolist()

						vim.fn.append(pos_line, lines)
					end)
			end

			vim.keymap.set("n", "<leader>o", append_new_lines(0), { expr = true })
			vim.keymap.set("n", "<leader>O", append_new_lines(-1), { expr = true })
		end,
	},
	{
		dir = "",
		name = "ryoppippi-paste-in-new-lines",
		dependencies = dependencies,
		keys = {
			"<leader>p",
			"<leader>P",
			"<leader>%",
		},
		config = function()
			local function paste_in_new_lines(direction)
				local peridot = require("peridot")
				return peridot
						and peridot.repeatable_edit(function(ctx)
							for _ = 1, ctx.count1 do
								if direction == 0 then
									vim.api.nvim_command("pu")
								elseif direction == -1 then
									vim.api.nvim_command("pu!")
								end
							end
						end)
					or ""
			end

			vim.keymap.set("n", "<leader>p", paste_in_new_lines(0), { expr = true })
			vim.keymap.set("n", "<leader>P", paste_in_new_lines(-1), { expr = true })
			vim.keymap.set("n", "<leader>%", paste_in_new_lines(-1), { expr = true })
		end,
	},
}
