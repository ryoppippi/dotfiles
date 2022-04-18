local M = {}

function M.t(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.is_vscode()
	return vim.g.vscode
end

function M.is_macos()
	return vim.loop.os_uname().sysname == "Darwin"
end

return M
