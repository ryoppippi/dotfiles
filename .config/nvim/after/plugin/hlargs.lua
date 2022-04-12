local status, hlargs = pcall(require, "hlargs")
if not status then
	return
end

hlargs.setup()
