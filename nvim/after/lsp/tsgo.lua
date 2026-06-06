--- Resolve the `tsgo` command for a given project root.
---
--- Resolution order:
--- 1. Project-local install at `<root>/node_modules/.bin/tsgo`.
--- 2. Global `tsgo` on PATH.
--- 3. `nix run nixpkgs#typescript-go` as a fallback, so tsgo works even on
---    machines where it is not installed, without polluting PATH.
---@param root string|nil project root directory
---@return string[] cmd argv used to spawn the language server
local function resolve_cmd(root)
	-- 1. Prefer a project-local install when present.
	if root then
		local local_bin = vim.fs.joinpath(root, "node_modules/.bin", "tsgo")
		if vim.fn.executable(local_bin) == 1 then
			return { local_bin, "--lsp", "--stdio" }
		end
	end

	-- 2. Use a globally installed tsgo on PATH.
	if vim.fn.executable("tsgo") == 1 then
		return { "tsgo", "--lsp", "--stdio" }
	end

	-- 3. Fall back to the nixpkgs build when tsgo is not installed.
	return { "nix", "run", "nixpkgs#typescript-go", "--", "--lsp", "--stdio" }
end

---@type vim.lsp.Config
return {
	single_file_support = false,
	workspace_required = true,
	cmd = function(dispatchers, config)
		return vim.lsp.rpc.start(resolve_cmd((config or {}).root_dir), dispatchers)
	end,
}
