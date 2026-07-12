--- Resolve the Nushell LSP command for a project root.
---
--- Flake projects may use Nushell syntax newer than the version bundled with
--- Neovim, so use the project's locked nixpkgs input when one is available.
---@param root string|nil project root directory
---@return string[] cmd argv used to spawn the language server
local function resolve_cmd(root)
	if
		root
		and vim.fn.filereadable(vim.fs.joinpath(root, "flake.nix")) == 1
		and vim.fn.filereadable(vim.fs.joinpath(root, "flake.lock")) == 1
	then
		return { "nix", "shell", "--inputs-from", root, "nixpkgs#nushell", "-c", "nu", "--lsp" }
	end

	return { "nu", "--lsp" }
end

---@type vim.lsp.Config
return {
	cmd = function(dispatchers, config)
		return vim.lsp.rpc.start(resolve_cmd((config or {}).root_dir), dispatchers)
	end,
	root_dir = function(bufnr, on_dir)
		local filename = vim.api.nvim_buf_get_name(bufnr)
		on_dir(vim.fs.root(filename, { "flake.lock", ".git" }) or vim.fs.dirname(filename))
	end,
}
