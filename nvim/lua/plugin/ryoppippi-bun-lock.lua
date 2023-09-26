return {
	dir = "",
	name = "ryoppippi/bun-lock",
	init = function()
		vim.api.nvim_create_autocmd("BufReadPost", {
			pattern = "bun.lockb",
			callback = function()
				-- get directory of the current buffer
				local dir = vim.fn.expand("%:p:h")
				-- if yarn.lock exists, rename to yarn_tmp.lock
				if vim.fn.filereadable(dir .. "/yarn.lock") == 1 then
					vim.fn.rename(dir .. "/yarn.lock", dir .. "/yarn_tmp.lock")
				end
				-- excecute command `bun install --dry-run --yarn`
				vim.fn.system("bun install --dry-run --yarn", dir)
				-- create a buffer
				vim.api.nvim_command("enew")
				-- read a yarn.lock and write to the buffer
				vim.api.nvim_buf_set_lines(0, 0, -1, true, vim.fn.readfile(dir .. "/yarn.lock"))
				-- set filetype to yarn.lock
				vim.opt_local.filetype = "conf"
				-- set readonly
				vim.opt_local.readonly = true
				-- set nomodifiable
				vim.opt_local.modifiable = false
				-- delete yarn.lock
				vim.fn.delete(dir .. "/yarn.lock")
				-- if yarn_tmp.lock exists, rename to yarn.lock
				if vim.fn.filereadable(dir .. "/yarn_tmp.lock") == 1 then
					vim.fn.rename(dir .. "/yarn_tmp.lock", dir .. "/yarn.lock")
				end
			end,
		})
	end,
}
