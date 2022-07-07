vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
require("auto-session").setup({
  log_level = "info",
  auto_session_root_dir = vim.fn.stdpath("cache") .. "/sessions/",
  auto_session_enabled = true,
  auto_session_create_enabled = true,
  auto_save_enabled = true,
  auto_save_restore_enabled = false,
})
