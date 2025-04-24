return {
	"ryoppippi/bun-to-deno",
	virtual = true,
	init = function()
		vim.api.nvim_create_user_command("BunToDeno", function()
			-- get current buffer text
			local text = vim.api.nvim_buf_get_lines(0, 0, -1, true)
			-- loop by lines
			for i, line in ipairs(text) do
				-- if the line stats with `import`
				if string.match(line, "^import") then
					-- import { hoge } from "hoge" => import { hoge } from "npm:hoge"
					-- import { hoge } from 'hoge' => import { hoge } from 'npm:hoge'
					text[i] = string.gsub(line, '"([^"]+)"', '"npm:%1"')
				end
			end
			-- set replaced text to current buffer
			vim.api.nvim_buf_set_lines(0, 0, -1, true, text)
		end, {})

		vim.api.nvim_create_user_command("DenoToBun", function()
			-- get current buffer text
			local text = vim.api.nvim_buf_get_lines(0, 0, -1, true)
			-- loop by lines
			for i, line in ipairs(text) do
				-- if the line stats with `import`
				if string.match(line, "^import") then
					-- import { hoge } from "npm:hoge" => import { hoge } from "hoge"
					-- import { hoge } from 'npm:hoge' => import { hoge } from 'hoge'
					text[i] = string.gsub(line, '"npm:([^"]+)"', '"%1"')
				end
			end
			-- set replaced text to current buffer
			vim.api.nvim_buf_set_lines(0, 0, -1, true, text)
		end, {})
	end,
}
