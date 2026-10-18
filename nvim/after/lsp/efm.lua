-- Generated next to efm's config.yaml by nix/modules/home/programs/efm-langserver.nix
local filetypes_file =
	vim.fs.joinpath(vim.env.XDG_CONFIG_HOME or vim.fs.normalize("~/.config"), "efm-langserver", "filetypes.json")

local function read_filetypes()
	local ok, lines = pcall(vim.fn.readfile, filetypes_file)
	if not ok then
		return nil
	end
	return vim.json.decode(table.concat(lines, "\n"))
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
