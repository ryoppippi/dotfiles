local function executable(cmd)
	return tb(vim.fn.executable(cmd))
end

---@type LazySpec
return {
	"thinca/vim-quickrun",
	cmd = "QuickRun",
	keys = {
		{ "qr", "QuickRun", mode = "ca" },
	},
	dependencies = {
		{ "tani/vim-artemis" },
		{ "lambdalisue/vim-quickrun-neovim-job" },
	},
	config = function()
		vimx.g.quickrun_config = {
			python = { command = "python3" },
			typescript = {
				type = executable("deno") and "typescript/deno"
					or executable("bun") and "typescript/bun"
					or executable("ts-node") and "typescript/ts-node"
					or "typescript/node",
			},
			["typescript/bun"] = {
				command = "bun",
				exec = "%c run %o %s",
			},
		}
	end,
}
