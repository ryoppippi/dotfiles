local M = {}

M.is_event_available = function(event)
	return tb(vim.fn.exists(("##" .. event)))
end

M.find_cmd = function(cmd, prefixes, start_from, stop_at)
	local path = require("lspconfig.util").path

	if type(prefixes) == "string" then
		prefixes = { prefixes }
	end

	local found
	for _, prefix in ipairs(prefixes) do
		local full_cmd = prefix and path.join(prefix, cmd) or cmd
		local possibility

		-- if start_from is a dir, test it first since transverse will start from its parent
		if start_from and path.is_dir(start_from) then
			possibility = path.join(start_from, full_cmd)
			if vim.fn.executable(possibility) > 0 then
				found = possibility
				break
			end
		end

		path.traverse_parents(start_from, function(dir)
			possibility = path.join(dir, full_cmd)
			if vim.fn.executable(possibility) > 0 then
				found = possibility
				return true
			end
			-- use cwd as a stopping point to avoid scanning the entire file system
			if stop_at and dir == stop_at then
				return true
			end
		end)

		if found ~= nil then
			break
		end
	end

	return found or cmd
end

function M.redetect_filetype()
	vim.bo.filetype = vim.bo.filetype
end

function M.repeat_element(x, n)
	local tbl = {}
	for _ = 1, n, 1 do
		table.insert(tbl, x)
	end
	return tbl
end

function M.combination(tbl1, tbl2, separator)
	local return_events = {}
	for _, ext in ipairs(tbl1) do
		for _, event in ipairs(tbl2) do
			table.insert(return_events, string.format("%s *.%s", event, ext))
		end
	end
	return return_events
end

function M.event_exe_combination(events, exts, init)
	return vim.tbl_flatten({
		init or {},
		M.combination(exts, events, " *."),
	})
end

return M
