local status, todo = pcall(require, "todo-comments")
if (not status) then return end

todo.setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
