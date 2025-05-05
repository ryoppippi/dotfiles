return {
	"mtdl9/vim-log-highlighting",
	event = function()
		local event = { "BufRead", "BufNewFile" }
		local filetype = " *{.,_}log"

		local return_events = {}
		for _, e in ipairs(event) do
			table.insert(return_events, e .. filetype)
		end
		return return_events
	end,
}
