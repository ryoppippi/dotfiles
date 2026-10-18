-- Generated next to efm's config.yaml by nix/modules/home/programs/efm-langserver.nix,
-- resolved the same way efm itself finds config.yaml
local filetypes_file =
	vim.fs.joinpath(vim.env.XDG_CONFIG_HOME or vim.fs.normalize("~/.config"), "efm-langserver", "filetypes.json")

---@return string[]
local function read_filetypes()
	local ok, filetypes = pcall(function()
		return vim.json.decode(table.concat(vim.fn.readfile(filetypes_file), "\n"))
	end)
	if ok and vim.islist(filetypes) then
		return filetypes
	end
	-- fail closed: an absent `filetypes` would attach efm to every buffer again
	vim.schedule(function()
		vim.notify(("efm disabled: cannot read %s"):format(filetypes_file), vim.log.levels.WARN)
	end)
	return {}
end

---@type vim.lsp.Config
return {
	cmd = { "efm-langserver" },
	filetypes = read_filetypes(),
	root_markers = {
		".git",
	},
	single_file_support = true,
	-- The config only defines format and lint commands; advertising more makes
	-- clients send requests efm rejects for every language
	init_options = {
		documentFormatting = true,
		rangeFormatting = true,
	},
}
