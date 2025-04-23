local o = {}

---@param client string | table
local function _convert_client(client)
	local _client = client
	if type(client) == "string" then
		_client = require("lspconfig")[client]
	end

	assert(_client)

	return _client
end

---@return boolean 'is cmp installed?'
function o.has_cmp()
	return require("core.plugin").has("nvim-cmp")
end

o.ft = {}
o.ft.js_like = {
	"javascript",
	"javascriptreact",
	"javascript.jsx",
	"typescript",
	"typescriptreact",
	"typescript.tsx",
}

o.ft.js_framework_like = vim.iter({
	o.ft.js_like,
	{
		"svelte",
		"astro",
		"vue",
	},
})
	:flatten(math.huge)
	:totable()

o.ft.markdown_like = {
	"markdown",
	"markdown.mdx",
}

o.ft.css_like = {
	"css",
	"scss",
	"less",
}

o.ft.html_like = vim.iter({
	o.ft.markdown_like,
	o.ft.css_like,
	o.ft.js_framework_like,
	{ "html", "htmldjango" },
})
	:flatten(math.huge)
	:totable()

o.ft.json_like = {
	"json",
	"jsonc",
	"json5",
}

o.ft.yaml_like = {
	"yaml",
	"yaml.docker-compose",
	"yaml.gitlab",
}

o.ft.config_like = vim.iter({
	o.ft.json_like,
	o.ft.yaml_like,
	{ "toml" },
})
	:flatten(math.huge)
	:totable()

o.ft.sh_like = {
	"sh",
	"bash",
	"zsh",
	"fish",
}

o.ft.deno_files = {
	"deno.json",
	"deno.jsonc",
	"denops",
	"package.json",
}

o.ft.node_specific_files = {
	"node_modules",
	"bun.lockb", -- bun
	"package-lock.json", -- npm or bun
	"npm-shrinkwrap.json", -- npm
	"yarn.lock", -- yarn
	"pnpm-lock.yaml", -- pnpm
}

o.ft.node_files = vim.iter({
	o.ft.node_specific_files,
	"package.json",
})
	:flatten(math.huge)
	:totable()

---Typescript inlay hints confis
o.typescriptInlayHints = {
	parameterNames = {
		enabled = "literals", -- 'none' | 'literals' | 'all'
		suppressWhenArgumentMatchesName = true,
	},
	parameterTypes = { enabled = false },
	variableTypes = { enabled = false },
	propertyDeclarationTypes = { enabled = true },
	functionLikeReturnTypes = { enabled = false },
	enumMemberValues = { enabled = true },
}

---Format config
---@param enabled boolean
function o.format_config(enabled)
	return function(client)
		client.server_capabilities.documentFormattingProvider = enabled
		client.server_capabilities.documentRangeFormattingProvider = enabled
	end
end

---@param client any
function o.get_default_filetypes(client)
	local _client = _convert_client(client)

	local document_config = _client.document_config
	if document_config ~= nil then
		return document_config.default_config.filetypes or {}
	end

	return {}
end

---Setup LSP client
---@param client any
---@param extra_opts LSPConfigOpts | nil
function o.setup(client, extra_opts)
	client = _convert_client(client)
	local local_opts = extra_opts or {}

	local_opts.filetypes = vim.iter({
		local_opts.filetypes or o.get_default_filetypes(client),
		local_opts.extra_filetypes or {},
	})
		:flatten()
		:totable()

	local_opts.extra_filetypes = nil
	client.setup(local_opts)
end

return o
