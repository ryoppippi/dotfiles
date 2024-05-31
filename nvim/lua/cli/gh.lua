local install = function(spec)
	local installedDir = spec.dir

	vim.system({ "gh", "extension", "install", "." }, { cwd = installedDir, text = true })
end

return {
	{ "yusukebe/gh-markdown-preview", build = { "go build", install } },
	{ "dlvhdr/gh-dash", build = { "go build", install } },
	{ "actions/gh-actions-cache", build = { "go build", install } },
	{ "seachicken/gh-poi", build = { "go build", install } },
	{ "k1LoW/gh-do", build = { install } },
	{ "kawarimidoll/gh-graph", build = { install } },
	{ "korosuke613/gh-user-stars", build = { install } },
	{ "github/gh-copilot", build = "gh extension install github/gh-copilot --force" },
}
