local function diagnostic_formatter(diagnostic)
	return string.format("[%s] %s (%s)", diagnostic.message, diagnostic.source, diagnostic.code)
end

return {
	on_attach = function(client, bufnr)
		-- setup diagnostic signs
		local signs = { Error = "", Warn = "", Hint = "", Info = "" }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end

		vim.diagnostic.config({
			underline = true,
			signs = true,
			update_in_insert = false,
			severity_sort = true,
			virtual_text = { format = diagnostic_formatter },
			float = { sformat = diagnostic_formatter },
		})
	end,
}
