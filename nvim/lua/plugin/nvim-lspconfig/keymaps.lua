local has = require("core.plugin").has
return {
	on_attach = function(_, bufnr)
		local function opts(desc)
			return { silent = true, buffer = bufnr, desc = desc }
		end

		local has_telescope = has("telescope.nvim")
		local has_glance = has("glance.nvim")
		local has_action_preview = has("actions-preview.nvim")

		-- hover doc
		vim.keymap.set("n", "gh", "<cmd>lua vim.lsp.buf.hover()<cr>", opts("hover doc"))

		-- jump to
		vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<cr>", opts("jump to declaration"))

		vim.keymap.set("n", "gd", function()
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
		vim.keymap.set("n", "gt", function()
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
		vim.keymap.set("n", "gI", function()
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
		vim.keymap.set("n", "gr", function()
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
		vim.keymap.set("i", "<C-k>", "<cmd>vim.lsp.buf.signature_help()<cr>", opts("signature_help"))
		vim.keymap.set("n", "gk", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts("signature_help"))

		-- diagnostics
		vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts("open diagnostics float"))
		if has_telescope then
			vim.keymap.set("n", "gL", [[<cmd>Telescope diagnostics<cr>]], opts("open diagnostics telescope"))
		end

		vim.keymap.set("n", "-", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts("goto next diagnostic"))
		vim.keymap.set("n", "_", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts("goto prev diagnostic"))

		-- rename
		vim.keymap.set("n", "cr", function()
			if require("core.plugin").has("inc-rename.nvim") then
				-- if ir then
				return ":IncRename " .. vim.fn.expand("<cword>")
			end
			return vim.lsp.buf.rename
		end, { expr = true, buffer = bufnr, desc = "rename words" })

		-- code actions
		vim.keymap.set({ "n", "v", "x" }, "ga", function()
			if has_action_preview then
				require("actions-preview").code_actions()
				return
			end
			vim.lsp.buf.code_action()
		end, opts("code_action"))

		-- workspace
		vim.keymap.set("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", opts("add workspace folder"))
		vim.keymap.set("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", opts("remove workspace folder"))
		vim.keymap.set("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", opts("list workspace folders"))
	end,
}
