local function diagnostic_formatter(diagnostic)
	return string.format("[%s] %s (%s)", diagnostic.message, diagnostic.source, diagnostic.code)
end

return {
	---@type OnAttachCallback
	on_attach = function(client, bufnr)
		-- setup diagnostic signs
		local signs = {
			Error = " ",
			Warn = " ",
			Info = " ",
			Hint = " ",
		}
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end

		vim.diagnostic.config({
			underline = true,
			signs = true,
			update_in_insert = false,
			severity_sort = true,
			virtual_text = false,
			float = { sformat = diagnostic_formatter },
			border = "single",
			title = "Diagnostics",
			header = {},
			suffix = {},
			format = function(diag)
				if diag.code then
					return string.format("[%s](%s): %s", diag.source, diag.code, diag.message)
				else
					return string.format("[%s]: %s", diag.source, diag.message)
				end
			end,
		})
	end,
}
