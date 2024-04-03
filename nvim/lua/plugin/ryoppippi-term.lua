return {
	dir = "",
	name = "ryoppippi-term.nvim",
	cmd = { "T", "Ts", "Tv", "Tg" },
	keys = {
		{ "g,", "<cmd>Tg<cr>" },
	},
	config = function()
		local function openTerm(args)
			local tf = vim.cmd.terminal
			if args == "" then
				tf()
			else
				tf(args)
			end
		end

		vim.api.nvim_create_user_command("T", function(tbl)
			local args = tbl.args
			vim.cmd.tabe()
			openTerm(args)
		end, { nargs = "*" })

		vim.api.nvim_create_user_command("Ts", function(tbl)
			local args = tbl.args
			vim.cmd.split()
			openTerm(args)
		end, { nargs = "*" })

		vim.api.nvim_create_user_command("Tv", function(tbl)
			local args = tbl.args
			vim.cmd.vsplit()
			openTerm(args)
		end, { nargs = "*" })

		vim.api.nvim_create_user_command("Tg", function()
			vim.cmd.tabe()
			vim.fn.termopen("lazygit", {
				on_exit = function(_, _, _)
					vim.cmd.tabclose()
				end,
			})
			local current_buffer = vim.api.nvim_get_current_buf()
			vim.keymap.set("t", "<esc>", "<esc>", { buffer = current_buffer, remap = false })
		end, { nargs = 0 })
	end,
}
