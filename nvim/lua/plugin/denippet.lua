local has = require("core.plugin").has

---@type LazySpec[]
return {
	{
		"https://github.com/uga-rosa/denippet.vim",
		cond = not is_vscode(),
		event = { "User DenopsReady" },
		dependencies = {
			"vim-denops/denops.vim",
			{
				"uga-rosa/cmp-denippet",
				cond = function()
					return has("nvim-cmp")
				end,
			},
			"nvim-lua/plenary.nvim",
			"tani/vim-artemis",
			"ryoppippi-snippets-list",
			"ryoppippi/denippet-autoimport-vscode",
		},
		init = function()
			vim.g.denippet_drop_on_zero = true
			vim.g.denippet_sync_delay = 100
		end,
		config = function(spec)
			require("denops-lazy").load(spec.name)
		end,
	},
	{
		"ryoppippi/denippet-autoimport-vscode",
		event = { "User DenopsReady" },
		dependencies = {
			"vim-denops/denops.vim",
			"ryoppippi-snippets-list",
		},
		config = function()
			require("denops-lazy").load("denippet-autoimport-vscode")

			local Popup = {}

			function Popup.new()
				return setmetatable({
					nsid = vim.api.nvim_create_namespace("denippet_choice_popup"),
				}, { __index = Popup })
			end

			function Popup:open(node)
				self.buf = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_buf_set_text(self.buf, 0, 0, 0, 0, node.items)
				local w, h = vim.lsp.util._make_floating_popup_size(node.items, {})
				self.win = vim.api.nvim_open_win(self.buf, false, {
					relative = "win",
					width = w,
					height = h,
					bufpos = { node.range.start.line, node.range.start.character },
					style = "minimal",
					border = "single",
				})
				self.extmark = vim.api.nvim_buf_set_extmark(
					self.buf,
					self.nsid,
					node.index,
					0,
					{ hl_group = "incsearch", end_line = node.index + 1 }
				)
			end

			function Popup:update()
				vim.api.nvim_buf_del_extmark(self.buf, self.nsid, self.extmark)
				local node = vim.b.denippet_current_node
				self.extmark = vim.api.nvim_buf_set_extmark(
					self.buf,
					self.nsid,
					node.index,
					0,
					{ hl_group = "incsearch", end_line = node.index + 1 }
				)
			end

			function Popup:close()
				if self.win then
					vim.api.nvim_win_close(self.win, true)
					self.buf = nil
					self.win = nil
					self.extmark = nil
				end
			end

			local popup = Popup.new()

			local group = vim.api.nvim_create_augroup("denippet_choice_popup", {})
			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "DenippetNodeEnter",
				callback = function()
					local node = vim.b.denippet_current_node
					if node and node.type == "choice" then
						popup:open(node)
					end
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "DenippetChoiceSelected",
				callback = function()
					popup:update()
				end,
			})
			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "DenippetNodeLeave",
				callback = function()
					popup:close()
				end,
			})
		end,
	},
}
