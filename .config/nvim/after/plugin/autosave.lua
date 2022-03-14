local status, autosave = pcall(require, "autosave")
if (not status) then return end

autosave.setup(
    {
        enabled = false,
        execution_message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
        -- events = {"BufLeave", "FocusLost", "WinLeave", "TextChanged", "QuitPre"},
        events = {"InsertLeave", "TextChanged"},
        conditions = {
            exists = true,
            filename_is_not = {},
            filetype_is_not = {},
            modifiable = true
        },
        write_all_buffers = false,
        on_off_commands = true,
        clean_command_line_interval = 0,
        debounce_delay = 135,
    }
)

vim.api.nvim_set_keymap('n', '<Leader>s', ":ASToggle<CR>", { noremap = true, silent = true })

