local uv = vim.loop

vim.b.is_pre_commit_pass = true
vim.b.is_commit_msg_pass = true

local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1] or ""
local git_hooks_path = vim.fn.systemlist("git config --get core.hooksPath")[1] or ".git/hooks"
local git_hooks_abs_path = vim.fn.resolve(git_root .. "/" .. git_hooks_path)
local pre_commit_path = vim.fn.resolve(git_hooks_abs_path .. "/pre-commit")
local commit_msg_path = vim.fn.resolve(git_hooks_abs_path .. "/commit-msg")

local commit_bufnr = vim.api.nvim_get_current_buf()
local commit_win_id = vim.fn.win_getid()
local abs_buffer_filename = vim.fn.expand("%:p")

vim.schedule(function()
	if tb(vim.fn.executable(pre_commit_path)) then
		vim.b.is_pre_commit_pass = false

		-- create buffer
		local new_bufnr = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_name(new_bufnr, "pre-commit")

		-- split window
		vim.cmd([[rightbelow vsplit]])
		local new_win_id = vim.api.nvim_get_current_win()

		-- set buffer to the split window
		vim.api.nvim_win_set_buf(new_win_id, new_bufnr)

		-- termopen
		vim.fn.termopen("cd " .. git_root .. " && " .. pre_commit_path, {
			on_exit = function()
				vim.b.is_pre_commit_pass = true
				vim.fn.win_gotoid(commit_win_id)
				vim.notify("pre_commit sucess", vim.log.levels.INFO)
			end,
		})
		vim.fn.win_gotoid(commit_win_id)
		vim.cmd.stopinsert()
	end
end)

vim.api.nvim_create_autocmd("BufWritePre", {
	buffer = commit_bufnr,
	callback = function()
		if not tb(vim.b.is_pre_commit_pass) then
			local err_msg = "Please wait for pre-commit hook."
			vim.notify(err_msg, vim.log.levels.ERROR)
			vim.api.nvim_err_writeln(err_msg)
			return false
		end
		return true
	end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
	buffer = commit_bufnr,
	callback = function()
		-- if commit-msg hook exists, run it
		if commit_msg_path ~= nil and tb(vim.fn.executable(commit_msg_path)) then
			vim.b.is_commit_msg_pass = false

			local stdout = uv.new_pipe()
			local stderr = uv.new_pipe()
			local handle

			local on_exit = function()
				if handle ~= nil then
					uv.close(handle)
				end
			end

			local opts = {
				args = { abs_buffer_filename },
				stdio = { nil, stdout, stderr },
			}

			handle = uv.spawn(commit_msg_path, opts, on_exit)

			if stdout ~= nil then
				uv.read_start(stdout, function(err, data)
					assert(not err, err)
					if data then
						vim.b.is_commit_msg_pass = true
						vim.notify(data, vim.log.levels.INFO)
						vim.notify("commit-msg hook succeeded.", vim.log.levels.INFO)
					end
				end)
			end

			if stderr ~= nil then
				uv.read_start(stderr, function(err, data)
					assert(not err, err)
					if data then
						vim.notify(err, vim.log.levels.ERROR)
						vim.notify("commit-msg hook failed.", vim.log.levels.ERROR)
						vim.cmd.throw(string.format("'%s'", err))
					end
				end)
			end
		end
	end,
})

vim.api.nvim_create_autocmd("BufDelete", {
	buffer = commit_bufnr,
	callback = function()
		if not vim.b.is_pre_commit_pass then
			vim.cmd.throw("Please wait for pre-commit and commit-msg hooks.")
		end
	end,
})
