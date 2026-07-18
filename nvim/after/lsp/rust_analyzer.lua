--- Resolve the `rust-analyzer` command.
---
--- Resolution order:
--- 1. `rust-analyzer` on PATH (e.g. from a project dev shell or rustup).
--- 2. `nix run nixpkgs#rust-analyzer` as a fallback, so Rust LSP works even
---    in projects whose toolchain does not ship rust-analyzer (e.g. a
---    rust-toolchain.toml without the rust-analyzer component).
---@return string[] cmd argv used to spawn the language server
local function resolve_cmd()
	if vim.fn.executable("rust-analyzer") == 1 then
		return { "rust-analyzer" }
	end
	return { "nix", "run", "nixpkgs#rust-analyzer" }
end

---@type vim.lsp.Config
return {
	cmd = resolve_cmd(),
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy",
			},
		},
	},
}
