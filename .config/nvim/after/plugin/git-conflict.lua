local status, conflict = pcall(require, 'git-conflict')
if not status then return end

conflict.setup()
