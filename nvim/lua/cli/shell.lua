return {
	{ "astral-sh/ruff-lsp", version = "*", build = { "rye install ruff-lsp -f" } },
	{ "microsoft/pyright", version = "1.*", build = { "rye install pyright -f" } },
}
