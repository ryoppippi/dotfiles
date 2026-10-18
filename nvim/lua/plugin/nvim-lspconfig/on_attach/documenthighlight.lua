local M = {}

local DELAY_MS = 500
local METHOD = "textDocument/documentHighlight"

---@type table<integer, uv.uv_timer_t>
local timers = {}

local function teardown(bufnr)
	local timer = timers[bufnr]
	if timer then
		timer:stop()
		timer:close()
		timers[bufnr] = nil
	end
	pcall(vim.api.nvim_del_augroup_by_name, ("lsp_document_highlight_%d"):format(bufnr))
end

---@type OnAttachCallback
M.on_attach = function(client, bufnr)
	-- a buffer with several capable clients only needs one set of autocmds
	if not client:supports_method(METHOD, bufnr) or timers[bufnr] then
		return
	end

	local timer = assert(vim.uv.new_timer())
	timers[bufnr] = timer
	local group = vim.api.nvim_create_augroup(("lsp_document_highlight_%d"):format(bufnr), { clear = true })
	local last_word, last_line

	vim.api.nvim_create_autocmd("CursorMoved", {
		group = group,
		buffer = bufnr,
		callback = function()
			-- staying on the same word keeps the current highlights instead of flickering
			local word, line = vim.fn.expand("<cword>"), vim.fn.line(".")
			if word == last_word and line == last_line then
				return
			end
			last_word, last_line = word, line

			vim.lsp.buf.clear_references()
			-- debounce: only ask the server once the cursor settles
			timer:start(
				DELAY_MS,
				0,
				vim.schedule_wrap(function()
					if vim.api.nvim_get_current_buf() == bufnr and vim.api.nvim_get_mode().mode == "n" then
						vim.lsp.buf.document_highlight()
					end
				end)
			)
		end,
	})

	vim.api.nvim_create_autocmd({ "InsertEnter", "BufLeave" }, {
		group = group,
		buffer = bufnr,
		callback = function()
			timer:stop()
			last_word, last_line = nil, nil
			vim.lsp.buf.clear_references()
		end,
	})

	vim.api.nvim_create_autocmd("LspDetach", {
		group = group,
		buffer = bufnr,
		callback = function(args)
			local remaining = vim.iter(vim.lsp.get_clients({ bufnr = bufnr, method = METHOD })):any(function(c)
				return c.id ~= args.data.client_id
			end)
			if not remaining then
				vim.lsp.buf.clear_references()
				teardown(bufnr)
			end
		end,
	})
end

return M
