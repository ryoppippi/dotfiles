return {
	-- python
	{ "astral-sh/ruff-lsp", version = "*", build = { "rye install ruff-lsp -f" } },
	{ "microsoft/pyright", version = "1.*", build = { "rye install pyright -f" } },
	-- ruby
	{ "Shopify/ruby-lsp", version = "*", build = { "gem install --user-install --no-document --pre ruby-lsp" } },
}
