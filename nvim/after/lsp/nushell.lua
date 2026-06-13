-- Resolve `nu` from $PATH so the user's own Nushell install is preferred
-- over any Nix-provided binary baked into Neovim's wrapper PATH.
local nu = vim.fn.exepath("nu")

---@type vim.lsp.Config
return {
	-- Fall back to the bare command name when `nu` is not on $PATH yet;
	-- the client simply won't spawn until a `nu` binary becomes available.
	cmd = { nu ~= "" and nu or "nu", "--lsp" },
}
