---@type LazySpec
return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	event = "VeryLazy",
	init = function()
		_G.dd = function(...)
			Snacks.debug.inspect(...)
		end
		_G.bt = function()
			Snacks.debug.backtrace()
		end
		vim.print = _G.dd
	end,
	keys = {
		-- Picker [[
		{
			",<cr>",
			function()
				Snacks.picker.picker_actions()
			end,
			desc = "Picker Actions",
		},
		{
			",,",
			function()
				Snacks.picker.smart()
			end,
			desc = "Smart Find Files",
		},
		{
			",<space>",
			function()
				Snacks.picker.grep()
			end,
			desc = "Grep",
		},
		{
			",b",
			function()
				Snacks.picker.grep_buffers()
			end,
			desc = "Grep Buffers",
		},
		{
			",s",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "Grep String",
			mode = { "n", "x" },
		},
		{
			",P",
			function()
				Snacks.picker.projects()
			end,
			desc = "Projects",
		},
		{
			",B",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			",c",
			function()
				Snacks.picker.colorschemes()
			end,
			desc = "Colorscheme",
		},
		{
			",f",
			function()
				Snacks.picker.files({
					hidden = true,
				})
			end,
			desc = "Find Files",
		},
		{
			",g",
			function()
				Snacks.picker.git_files()
			end,
			desc = "Git Files",
		},
		{
			",h",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Pages",
		},
		{
			",j",
			function()
				Snacks.picker.jumps()
			end,
			desc = "Jumplist",
		},
		{
			",l",
			function()
				Snacks.picker.lazy()
			end,
			desc = "Lazy",
		},
		{
			",m",
			function()
				Snacks.picker.marks()
			end,
			desc = "Marks",
		},
		{
			",p",
			function()
				Snacks.picker.commands()
			end,
			desc = "Commands",
		},
		{
			",q",
			function()
				Snacks.picker.qflist()
			end,
			desc = "qflist",
		},
		{
			",r",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume",
		},
		{
			",t",
			function()
				Snacks.picker.todo_comments()
			end,
			desc = "TODO",
		},
		{
			",i",
			function()
				Snacks.picker.icons()
			end,
			desc = "Icons",
		},
		{
			",z",
			function()
				Snacks.picker.zoxide()
			end,
			desc = "Zoxide",
		},
		{
			",d",
			function()
				Snacks.picker.diagnostics_buffer()
			end,
		},
		{
			",D",
			function()
				Snacks.picker.diagnostics()
			end,
		},
		-- Picker ]]
		-- Dim [[
		{
			"<leader>d",
			function()
				if Snacks.dim.enabled then
					Snacks.dim.disable()
				else
					Snacks.dim.enable()
				end
			end,
			desc = "Dim",
		},
		-- Dim ]]
	},
	---@type snacks.Config
	opts = {
		input = {
			enabled = true,
		},
		picker = {
			ui_select = true,
			formatters = {
				file = {
					filename_first = true,
					truncate = 400,
				},
			},
		},
		bigfile = {
			enabled = true,
		},
		scratch = {
			enabled = true,
		},
		debug = {
			enabled = true,
		},
	},
}
