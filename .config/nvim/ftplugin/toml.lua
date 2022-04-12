local status, cmp = pcall(require, "cmp")
if status then
  local sources = cmp.get_config().sources
  for i = #sources, 1, -1 do
    if sources[i].name == 'treesitter' then
      table.remove(sources, i)
    end
  end
  cmp.setup.buffer({ sources = sources })
end
