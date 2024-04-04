---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts vim.keymap.set.Opts
local function keyset(mode, lhs, rhs, opts)
	local maparg = vim.fn.maparg
	local empty = vim.fn.empty

	if type(mode) == "table" then
		for _, m in ipairs(mode) do
			vim.keymap.set(m, lhs, rhs, opts)
		end
		return
	end

	if tb(empty(maparg(lhs, mode))) then
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

return {
	on_attach = function(_, bufnr)
		---@param desc string
		---@return vim.keymap.set.Opts
		local function opts(desc)
			return { silent = true, buffer = bufnr, desc = desc }
		end

		local has = require("core.plugin").has
		local has_telescope = has("telescope.nvim")
		local has_glance = has("glance.nvim")
		local has_action_preview = has("actions-preview.nvim")
		local has_inc_rename = has("inc-rename.nvim")

		-- hover doc
		keyset("n", "gh", vim.lsp.buf.hover, opts("hover doc"))

		-- jump to
		-- keyset("n", "gD", vim.lsp.buf.declaration, opts("jump to declaration"))

		keyset("n", "gd", function()
			if has_glance then
				vim.cmd([[Glance definitions]])
				return
			end
			if has_telescope then
				vim.cmd([[Telescope lsp_definitions]])
				return
			end
			vim.lsp.buf.type_definition()
		end, opts("jump to definition"))
		keyset("n", "gt", function()
			if has_glance then
				vim.cmd([[Glance type_definitions]])
				return
			end
			if has_telescope then
				vim.cmd([[Telescope lsp_type_definitions]])
				return
			end
			vim.lsp.buf.type_definition()
		end, opts("jump to type_definition"))
		keyset("n", "gI", function()
			if has_glance then
				vim.cmd([[Glance implementations]])
				return
			end
			if has_telescope then
				vim.cmd([[Telescope lsp_implementations]])
				return
			end
			vim.lsp.buf.implementation()
		end, opts("jump to implementation"))
		keyset("n", "gr", function()
			if has_glance then
				vim.cmd([[Glance references]])
				return
			end
			if has_telescope then
				vim.cmd([[Telescope lsp_references]])
				return
			end
			vim.lsp.buf.references()
		end, opts("jump to references"))

		-- signature_help
		keyset("i", "<C-k>", vim.lsp.buf.signature_help, opts("signature_help"))
		keyset("n", "gk", vim.lsp.buf.signature_help, opts("signature_help"))

		-- diagnostics
		keyset("n", "gl", vim.diagnostic.open_float, opts("open diagnostics float"))
		if has_telescope then
			keyset("n", "gL", [[<cmd>Telescope diagnostics<cr>]], opts("open diagnostics telescope"))
		end

		keyset("n", "-", vim.diagnostic.goto_next, opts("goto next diagnostic"))
		keyset("n", "_", vim.diagnostic.goto_prev, opts("goto prev diagnostic"))

		-- rename
		keyset("n", "cr", function()
			if has_inc_rename then
				require("inc_rename")
				return ":IncRename " .. vim.fn.expand("<cword>")
			end
			return ":lua vim.lsp.buf.rename()<cr>"
		end, vim.tbl_deep_extend("error", { expr = true }, opts("rename")))

		-- code actions
		keyset({ "n", "v", "x" }, "ga", function()
			if has_action_preview then
				require("actions-preview").code_actions()
				return
			end
			vim.lsp.buf.code_action()
		end, opts("code_action"))

		-- workspace
		keyset("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts("add workspace folder"))
		keyset("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts("remove workspace folder"))
		keyset("n", "<leader>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts("list workspace folders"))
	end,
}
