return {
	"dmmulroy/ts-error-translator.nvim",
	event = function()
		local return_events = { "VeryLazy" }
		local events = { "BufReadPre", "BufNewFile" }
		local exts = { "js", "jsx", "ts", "tsx" }
		for _, ext in ipairs(exts) do
			for _, event in ipairs(events) do
				table.insert(return_events, ("%s *.%s"):format(event, ext))
			end
		end
		return return_events
	end,
	config = true,
}
