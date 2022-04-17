local status, hclipboard = pcall(require, "hclipboard")
if not status then
	return
end

hclipboard.start()
