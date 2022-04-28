local status, iswap = pcall(require, "iswap")
if not status then
  return
end
iswap.setup({})
