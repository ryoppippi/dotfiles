local plugin_name = "lspsaga"
if not require("utils.plugin").is_exists(plugin_name) then
	return
end

local loading = function()
	require(plugin_name).setup({
		use_saga_diagnostic_sign = true,
		error_sign = " ",
		warn_sign = " ",
		infor_sign = " ",
		hint_sign = "",
		border_style = "round",
	})

	local lspsaga_filetypes = vim.api.nvim_create_augroup("lspsaga_filetypes", { clear = true })
	vim.api.nvim_create_autocmd("Filetype", {
		pattern = "LspsagaHover",
		callback = function()
			vim.keymap.set({ "n" }, [[<ESC>]], [[<cmd>q<cr>]], { silent = true, nowait = true, buffer = true })
		end,
		group = lspsaga_filetypes,
	})
end

local function keymap()
	vim.keymap.set("n", "<C-j>", [[<cmd>Lspsaga diagnostic_jump_next<cr>]], { silent = true, noremap = true })
	vim.keymap.set("n", "gh", [[<cmd>Lspsaga hover_doc<cr>]], { silent = true, noremap = true })
	-- vim.keymap.set('n', 'gj', [[<cmd>Lspsaga preview_definition<cr>]], { silent = true, noremap = true })
	vim.keymap.set("n", "gk", [[<cmd>Lspsaga signature_help<cr>]], { silent = true, noremap = true })
	vim.keymap.set("n", "gK", [[<cmd>Lspsaga lsp_finder<cr>]], { silent = true, noremap = true })

	vim.keymap.set("n", "gj", [[<cmd>Lspsaga show_line_diagnostics<cr>]], { silent = true, noremap = true })
	vim.keymap.set("n", "-", [[<cmd>Lspsaga diagnostic_jump_next<cr>]], { silent = true, noremap = true })
	vim.keymap.set("n", "_", [[<cmd>Lspsaga diagnostic_jump_prev<cr>]], { silent = true, noremap = true })

	vim.keymap.set("n", "cW", [[<cmd>Lspsaga rename<cr>]], { silent = true, noremap = true })

	vim.keymap.set("n", "<leader>ag", [[<cmd>Lspsaga open_floaterm lazygit<cr>]], { silent = true, noremap = true })
	vim.keymap.set("n", "<leader>aa", [[<cmd>Lspsaga open_floaterm<cr>]], { silent = true, noremap = true })
	vim.keymap.set("n", "<leader>ac", [[<cmd>Lspsaga close_floaterm<cr>]], { silent = true, noremap = true })
	vim.keymap.set("t", "<ESC>", [[<cmd>Lspsaga close_floaterm<cr>]], { silent = true, noremap = true })
end

local function callback()
	loading()
	keymap()
end

require("utils.plugin").force_load_on_event(plugin_name, callback)
