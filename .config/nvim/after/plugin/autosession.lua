local status, autosession = pcall(require, "auto-session")
if (not status) then return end

local opts = {
        log_level = 'info',
        auto_session_enabled = true,
        auto_session_create_enabled = true,
        auto_save_enabled = true,
        auto_save_restore_enabled = true,
}

autosession.setup(opts)
