local M = {}

function M.init()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"--single-branch",
			"https://github.com/folke/lazy.nvim.git",
			lazypath,
		})
	end
	vim.opt.runtimepath:prepend(lazypath)
end

---@param on_attach fun(client, buffer)
function M.on_attach(on_attach)
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, buffer)
		end,
	})
end

---@param plugin string
function M.has(plugin)
	return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

return M
