local status, scrollbar = pcall(require, "scrollbar")
if not status then
	return
end
-- require("scrollbar.handlers.search").setup()
scrollbar.setup()
