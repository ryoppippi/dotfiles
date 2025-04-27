local filetypes = {
	"javascript",
	"javascriptreact",
	"javascript.jsx",
	"typescript",
	"typescriptreact",
	"typescript.tsx",
	"svelte",
	"astro",
	"vue",
}

---@type LazySpec
return {
	"mxsdev/nvim-dap-vscode-js",
	ft = filetypes,
	keys = {
		{
			"ma",
			function()
				if vim.fn.filereadable(".vscode/launch.json") then
					local dap_vscode = require("dap.ext.vscode")
					dap_vscode.load_launchjs(nil, {
						["pwa-node"] = filetypes,
						["chrome"] = filetypes,
						["pwa-chrome"] = filetypes,
					})
				end
				require("dap").continue()
			end,
			desc = "Run with Args",
		},
	},
	dependencies = {
		"mfussenegger/nvim-dap",
		{
			"microsoft/vscode-js-debug",
			build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
		},
	},
	opts = {
		debugger_path = vim.fn.resolve(vim.fn.stdpath("data") .. "/lazy/vscode-js-debug"),

		adapters = {
			"chrome",
			"pwa-node",
			"pwa-chrome",
			"pwa-msedge",
			"pwa-extensionHost",
			"node-terminal",
		},
	},
	config = function(_, opts)
		require("dap-vscode-js").setup(opts)

		local dap = require("dap")

		for _, language in ipairs(filetypes) do
			dap.configurations[language] = {
				-- Debug single nodejs files
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
					sourceMaps = true,
				},
				-- Debug nodejs processes (make sure to add --inspect when you run the process)
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}/src",
					sourceMaps = true,
					skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
				},
				-- Debug web applications (client side)
				{
					type = "pwa-chrome",
					request = "launch",
					name = "Launch & Debug Chrome",
					url = function()
						local co = coroutine.running()
						return coroutine.create(function()
							vim.ui.input({
								prompt = "Enter URL: ",
								default = "http://localhost:5173",
							}, function(url)
								if url == nil or url == "" then
									return
								else
									coroutine.resume(co, url)
								end
							end)
						end)
					end,
					webRoot = vim.fn.getcwd(),
					protocol = "inspector",
					skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
					sourceMaps = true,
					userDataDir = false,
				},
			}
		end
	end,
}
