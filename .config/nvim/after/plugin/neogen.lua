local status, neogen = pcall(require, "neogen")
if not status then
	return
end
neogen.setup()
