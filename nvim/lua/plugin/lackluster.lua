local function isLackluster()
	return vim.env.NVIM_COLORSCHEME == "lackluster"
end

---@type LazySpec
return {
	"slugbyte/lackluster.nvim",
	priority = isLackluster() and 1000 or 50,
	event = isLackluster() and { "UiEnter" } or { "VeryLazy" },
	config = function()
		if isLackluster() then
			vim.cmd.colorscheme("lackluster")
		end
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "lackluster",
			callback = function() end,
		})
	end,
}
