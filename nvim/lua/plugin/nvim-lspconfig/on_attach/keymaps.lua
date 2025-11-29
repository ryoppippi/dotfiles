-- delete Neovim 0.11 builtin LSP keymaps
for _, key in ipairs({ "gra", "gri", "grn", "grr", "grt" }) do
	pcall(vim.keymap.del, "n", key)
end

---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param opts vim.keymap.set.Opts
local function keyset(mode, lhs, rhs, opts)
	local maparg = vim.fn.maparg

	if type(mode) == "table" then
		for _, m in ipairs(mode) do
			keyset(m, lhs, rhs, opts)
		end
		return
	end

	local function is_nop(_lhs, _mode)
		local keymap = maparg(_lhs, _mode)
		return (keymap == "" or keymap:lower() == "<nop>")
	end

	if is_nop(lhs, mode) then
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end

return {
	---@type OnAttachCallback
	on_attach = function(_, bufnr)
		---@param desc string
		---@return vim.keymap.set.Opts
		local function opts(desc)
			return { silent = true, buffer = bufnr, desc = desc }
		end

		local has = require("core.plugin").has
		local has_snacks = has("snacks.nvim")
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
			if has_snacks then
				Snacks.picker.lsp_definitions()
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
			if has_snacks then
				Snacks.picker.lsp_type_definitions()
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
			if has_snacks then
				Snacks.picker.lsp_implementations()
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
			if has_snacks then
				Snacks.picker.lsp_references()
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
