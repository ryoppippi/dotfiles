return {
	dir = "",
	name = "ryoppippi/bun-lock",
	init = function()
		vim.api.nvim_create_autocmd("BufReadCmd", {
			pattern = "bun.lockb",
			callback = function()
				-- get the absolute path of the current file
				local path = vim.fn.expand("%:p")
				-- run command 'bun ' .. path and get stdout
				local output = vim.fn.systemlist("bun " .. path)
				-- set output to current buffer
				vim.api.nvim_buf_set_lines(0, 0, -1, true, output)
				-- set filetype to yarn.lock
				vim.opt_local.filetype = "conf"
				-- set readonly
				vim.opt_local.readonly = true
				-- set nomodifiable
				vim.opt_local.modifiable = false
			end,
		})
	end,
}
