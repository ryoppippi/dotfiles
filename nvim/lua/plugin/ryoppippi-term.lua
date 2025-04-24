return {
	"ryoppippi-term.nvim",
	virtual = true,
	cmd = { "T", "TS", "TV" },
	keys = {
		{ "<leader>tt", "<cmd>T<cr>" },
		{ "<leader>ts", "<cmd>TS<cr>" },
		{ "<leader>tv", "<cmd>TV<cr>" },
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

		vim.api.nvim_create_user_command("TS", function(tbl)
			local args = tbl.args
			vim.cmd.split()
			openTerm(args)
		end, { nargs = "*" })

		vim.api.nvim_create_user_command("TV", function(tbl)
			local args = tbl.args
			vim.cmd.vsplit()
			openTerm(args)
		end, { nargs = "*" })
	end,
}
