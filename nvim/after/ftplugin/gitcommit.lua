local Path = require("plenary.path")
local has = require("core.plugin").has

local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1] or ""
local git_hooks_path = vim.fn.systemlist("git config --get core.hooksPath")[1] or ".git/hooks"
local git_hooks_abs_path = Path:new(git_root, git_hooks_path):absolute()
local pre_commit_path = Path:new(git_hooks_abs_path, "pre-commit"):absolute()
local commit_msg_path = Path:new(git_hooks_abs_path, "commit-msg"):absolute()

local commit_bufnr = vim.api.nvim_get_current_buf()
local commit_win_id = vim.fn.win_getid()
local abs_buffer_filename = vim.fn.expand("%:p")

vim.b.is_pre_commit_pass = not tb(vim.fn.executable(pre_commit_path))
vim.b.is_commit_msg_pass = not tb(vim.fn.executable(commit_msg_path))

local cquit_if_not_passed = function()
	if not vim.b.is_pre_commit_pass or not vim.b.is_commit_msg_pass then
		vim.cmd.cquit()
	end
end

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

		-- delete buffer if commit buffer is deleted
		vim.api.nvim_create_autocmd("WinClosed", {
			buffer = commit_bufnr,
			callback = function()
				vim.api.nvim_buf_delete(new_bufnr, { force = true })
			end,
		})

		-- termopen
		vim.fn.termopen("cd " .. git_root .. " && " .. pre_commit_path, {
			on_exit = function(_, exit_code, _)
				if exit_code ~= 0 then
					vim.notify("pre-commit failed", vim.log.levels.ERROR)
				else
					vim.notify("pre_commit success", vim.log.levels.INFO)
				end
				vim.b.is_pre_commit_pass = exit_code == 0
			end,
		})
		vim.fn.win_gotoid(commit_win_id)
		vim.cmd.stopinsert()
	end
end)

vim.api.nvim_create_autocmd("BufWritePost", {
	buffer = commit_bufnr,
	callback = function()
		if not tb(vim.b.is_pre_commit_pass) then
			local err_msg = "Please wait for pre-commit hook."
			vim.notify(err_msg, vim.log.levels.ERROR)
			vim.api.nvim_err_writeln(err_msg)
		end

		if tb(vim.fn.executable(commit_msg_path)) then
			vim.b.is_commit_msg_pass = false

			vim.fn.jobstart(commit_msg_path .. " " .. abs_buffer_filename, {
				on_exit = function(_, exit_code, _)
					if exit_code ~= 0 then
						vim.notify("commit-msg hook failed.", vim.log.levels.ERROR)
					else
						vim.notify("commit-msg hook succeeded.", vim.log.levels.INFO)
					end
					vim.b.is_commit_msg_pass = exit_code == 0
				end,
				on_stderr = function(_, data, _)
					vim.notify(vim.fn.join(data, "\n"), vim.log.levels.ERROR)
				end,
				on_stdout = function(_, data, _)
					vim.notify(vim.fn.join(data, "\n"), vim.log.levels.INFO)
				end,
			})
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufDelete" }, {
	buffer = commit_bufnr,
	callback = cquit_if_not_passed,
})
