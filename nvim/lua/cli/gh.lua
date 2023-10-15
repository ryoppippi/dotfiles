local link = function(spec)
	local installedDir = spec.dir
	local name = spec.name

	-- get xdg data dir
	local xdgDataDir = os.getenv("XDG_DATA_HOME") or os.getenv("HOME") .. "/.local/share"
	local ghExtensionDir = xdgDataDir .. "/gh/extensions"

	-- vim.uv.fs_mkdir(ghExtensionDir, 511)
	vim.fn.mkdir(ghExtensionDir, "p")
	vim.uv.fs_symlink(installedDir, ghExtensionDir .. "/" .. name)
end

return {
	{ "yusukebe/gh-markdown-preview", build = { "go clean", "go build", link } },
	{ "dlvhdr/gh-dash", build = { "go clean", "go build", link } },
	{ "actions/gh-actions-cache", build = { "go clean", "go build", link } },
	{ "seachicken/gh-poi", build = { "go clean", "go build", link } },
	{ "k1LoW/gh-do", build = { link } },
	{ "kawarimidoll/gh-graph", build = { link } },
	{ "kawarimidoll/gh-q", build = { link } },
}
