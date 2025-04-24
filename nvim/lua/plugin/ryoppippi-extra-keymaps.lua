local dependencies = { "monaqa/peridot.vim", "nvim-lua/plenary.nvim" }

---@type LazySpec
return {
	{
		"ryoppippi-append-new-lines",
		virtual = true,
		dependencies = dependencies,
		keys = {
			{ "<leader>o", "<Plug>(append-new-lines-forward)" },
			{ "<leader>O", "<Plug>(append-new-lines-backward)" },
		},
		config = function()
			local function append_new_lines(offset_line)
				local peridot = require("peridot")
				return peridot
					and peridot.repeatable_edit(function(ctx)
						local curpos = vim.fn.line(".")
						local pos_line = curpos + offset_line
						local n_lines = ctx.count1
						local lines = vim.iter(vim.fn.range(n_lines)):map(_l([[: ""]])):totable()

						vim.fn.append(pos_line, lines)
					end)
			end

			vim.keymap.set("n", "<Plug>(append-new-lines-forward)", append_new_lines(0), { expr = true })
			vim.keymap.set("n", "<Plug>(append-new-lines-backward)", append_new_lines(-1), { expr = true })
		end,
	},
	{
		"ryoppippi-paste-in-new-lines",
		virtual = true,
		dependencies = dependencies,
		keys = {
			{ "<leader>p" },
			{ "<leader>P" },
			{ "<leader>%" },
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
