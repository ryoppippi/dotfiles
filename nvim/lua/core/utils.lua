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

---@param path string
M.open_file_with_quicklook = function(path)
	vim.cmd(("silent !qlmanage -p %s &"):format(path))
end

---Debounce a function
---@param func function
---@param wait number
function M.debounce(func, wait)
	local timer_id
	---@vararg any
	return function(...)
		if timer_id ~= nil then
			vim.uv.timer_stop(timer_id)
		end
		local args = { ... }
		timer_id = assert(vim.uv.new_timer())
		vim.uv.timer_start(timer_id, wait, 0, function()
			func(unpack(args))
			timer_id = nil
		end)
	end
end

---Throttle a function(execute instantly and ignore the next calls within the wait time))
---@param func function
---@param wait number
function M.throttle(func, wait)
	local last_call = 0
	---@vararg any
	return function(...)
		local now = vim.uv.now()
		if now - last_call > wait then
			func(...)
			last_call = now
		end
	end
end

return M
