local plugin_name = "vim-print-debug"

local function loading()
  vim.keymap.set("n", "sp", "<cmd>call print_debug#print_debug()<cr>", { noremap = true })
  -- vim.g.print_debug_templates = {
  --   go = 'fmt.Printf("+++ {}\n")',
  --   python = 'print(f"+++ {}")',
  --   javascript = "console.log(`+++ {}`);",
  --   typescript = "console.log(`+++ {}`);",
  --   typescriptreact = "console.log(`+++ {}`);",
  --   c = 'printf("+++ {}\n");',
  --   rust = 'println!("+++ {}\n");',
  --   sh = 'echo "+++ {}"',
  --   zsh = 'echo "+++ {}"',
  -- }
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
