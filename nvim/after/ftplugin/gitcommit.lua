local uv = vim.loop
local Promise = require("promise")

local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1] or ""
local git_hooks_path = vim.fn.systemlist("git config --get core.hooksPath")[1] or ".git/hooks"
local git_hooks_abs_path = vim.fn.resolve(git_root .. "/" .. git_hooks_path)
local pre_commit_path = vim.fn.resolve(git_hooks_abs_path .. "/pre-commit")
local commit_msg_path = vim.fn.resolve(git_hooks_abs_path .. "/commit-msg")

local commit_bufnr = vim.api.nvim_get_current_buf()
local commit_win_id = vim.fn.win_getid()
local abs_buffer_filename = vim.fn.expand("%:p")

vim.b.is_enable_to_save = true

vim.api.nvim_create_autocmd("BufWriteCmd", {
	buffer = commit_bufnr,
	callback = function()
		-- if pre-commit hook is running, do not save
		if not vim.b.is_enable_to_save then
			local err_msg = "Please wait for pre-commit hook."
			vim.notify(err_msg, vim.log.levels.ERROR)
			vim.cmd.throw(string.format("'%s'", err_msg))
		end

		-- if commit-msg hook exists, run it
		if commit_msg_path ~= nil and tb(vim.fn.executable(commit_msg_path)) then
			Promise.new(function(resolve, reject)
				local stdout = uv.new_pipe()
				local stderr = uv.new_pipe()
				local handle

				local on_exit = function(status)
					uv.close(handle)
				end

				local opts = {
					args = { abs_buffer_filename },
					stdio = { nil, stdout, stderr },
				}

				handle = uv.spawn(commit_msg_path, opts, on_exit)

				uv.read_start(stdout, function(err, data)
					assert(not err, err)
					if data then
						resolve(data)
					end
				end)

				uv.read_start(stderr, function(err, data)
					assert(not err, err)
					if data then
						reject(data)
					end
				end)
			end)
				:next(function(msg)
					vim.notify(msg, vim.log.levels.INFO)
					vim.notify("commit-msg hook succeeded.", vim.log.levels.INFO)
				end)
				:catch(function(err)
					vim.notify(err, vim.log.levels.ERROR)
					vim.notify("commit-msg hook failed.", vim.log.levels.ERROR)
					vim.cmd.throw(string.format("'%s'", err))
				end)
		end
	end,
})

if tb(vim.fn.executable(pre_commit_path)) then
	vim.b.is_enable_to_save = false

	-- create buffer
	local new_bufnr = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(new_bufnr, "pre-commit")

	-- split window
	vim.cmd([[rightbelow vsplit]])
	local new_win_id = vim.api.nvim_get_current_win()

	-- set buffer to the split window
	vim.api.nvim_win_set_buf(new_win_id, new_bufnr)

	-- set autocmd to delete buffer when closing window
	vim.api.nvim_create_autocmd("QuitPre", {
		buffer = new_bufnr,
		callback = function()
			vim.cmd.bdelete({ new_bufnr, bang = true })
		end,
	})

	-- termopen
	vim.fn.termopen("cd " .. git_root .. " && " .. pre_commit_path, {
		on_exit = function()
			vim.fn.win_gotoid(commit_win_id)
			vim.b.is_enable_to_save = true
		end,
	})
	vim.fn.win_gotoid(commit_win_id)
	vim.cmd.stopinsert()
end
