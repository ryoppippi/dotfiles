local M = {}

M.is_event_available = function(event)
	return tb(vim.fn.exists(("##" .. event)))
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
