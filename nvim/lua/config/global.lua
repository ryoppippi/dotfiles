_G.tb = function(value)
	if value == nil then
		return false
	elseif type(value) == "boolean" then
		return value
	elseif type(value) == "number" then
		return value ~= 0
	elseif type(value) == "string" then
		return string.lower(value) == "true"
	else
		return false
	end
end

_G.t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

_G.is_vscode = function()
	return tb(vim.g.vscode)
end

_G.is_macos = function()
	return vim.loop.os_uname().sysname == "Darwin"
end
